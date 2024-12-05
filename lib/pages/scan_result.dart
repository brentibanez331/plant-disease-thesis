import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:thesis/models/disease.dart";
import "package:thesis/models/prediction_result.dart";
import "package:thesis/services/plant_predict_service.dart";
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:thesis/utils/colors.dart";
import "package:thesis/widgets/fullscreen_image.dart";

class ScanResultPage extends StatefulWidget {
  final XFile xImage;
  final bool newPrediction;
  final VoidCallback refreshAllData;

  const ScanResultPage(
      {super.key,
      required this.xImage,
      this.newPrediction = true,
      required this.refreshAllData});

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  File? image;
  File? scaledImage;
  bool _isLoading = true;
  bool _requestFailed = false;
  late PredictionResult predictionResult;
  late DiseaseInfo diseaseInfo;
  var dateFormatter = DateFormat('MMM d, h:mm a');

  static const storage = FlutterSecureStorage();
  late String? token;
  late String? userId;

  // var dateFormatter = DateFormat('MMM d, yyyy');
  // var dateTimeFormatter = DateFormat('MMMM d, yyyy - hh:mm:ss a');

  @override
  void initState() {
    super.initState();
    getToken();
    image = File(widget.xImage.path);

    if (widget.newPrediction) {
      predictDisease(image);
    }
  }

  Future<void> getToken() async {
    token = await storage.read(key: 'token');
    userId = await storage.read(key: 'userId');
  }

  Future<File> resizeAndCropImage(File file) async {
    // Read the image from file
    img.Image? image = img.decodeImage(await file.readAsBytes());

    if (image != null) {
      // Calculate the center square dimensions
      int size = image.width < image.height ? image.width : image.height;
      int x = (image.width - size) ~/ 2;
      int y = (image.height - size) ~/ 2;

      // Crop square in the center
      image = img.copyCrop(image, x: x, y: y, width: size, height: size);

      // Resize image to 224x224
      image = img.copyResize(image, width: 224, height: 224);

      // Convert image to bytes
      List<int> resizedBytes = img.encodePng(image);

      // Create a new file or overwrite the original file
      File resizedFile = File(file.path);
      await resizedFile.writeAsBytes(resizedBytes);

      return resizedFile;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> predictDisease(File? image) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _requestFailed = false;
    });

    scaledImage = await resizeAndCropImage(image!);

    try {
      log("GCP_API URL: ${dotenv.env["GCP_API"]}");
      var request =
          http.MultipartRequest("POST", Uri.parse(dotenv.env["GCP_API"]!));
      request.files
          .add(await http.MultipartFile.fromPath("file", scaledImage!.path));

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (!mounted) return;

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log("Raw JSON response from Predict: $jsonResponse");

        predictionResult = PredictionResult.fromJson(jsonResponse);

        // Make another API request for the Scan Info Storing
        if (predictionResult.plant != "Background") {
          await getDiseaseInformation();
          await storeScanResult();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please take an image of an actual plant!"),
            backgroundColor: Colors.green, // Change color if needed
          ));
          Navigator.pop(context);
        }

        widget.refreshAllData();

        setState(() {
          _requestFailed = false;
        });
      } else {
        log("Error: ${response.statusCode}");
        setState(() {
          _requestFailed = true;
        });
      }
    } catch (e) {
      log("Prediction Exception: $e");
      if (mounted) {
        setState(() {
          _requestFailed = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> getDiseaseInformation() async {
    if (scaledImage == null) {
      log("Prediction result or scaled image is null");
      return;
    }

    if (token!.isEmpty) {
      log("Not authorized");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            "${dotenv.env['ROOT_DOMAIN']}/api/disease/search?plant=${predictionResult.plant}&disease=${predictionResult.status}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        diseaseInfo = DiseaseInfo.fromJson(data[0]);
      } else {
        setState(() {
          _requestFailed = false;
        });
      }
    } catch (e) {
      log("DiseaseInfo Exception: $e");
      setState(() {
        _requestFailed = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> storeScanResult() async {
    if (scaledImage == null) {
      log("Prediction result or scaled image is null");
      return;
    }

    if (token!.isEmpty) {
      log("Not authorized");
      return;
    }

    var apiUrl = "${dotenv.env['ROOT_DOMAIN']}/api/scan/add";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(await http.MultipartFile.fromPath(
          'Image', scaledImage!.path,
          filename: path.basename(scaledImage!.path)));

      request.fields['UserId'] = userId!;
      request.fields['Plant'] = predictionResult.plant;
      request.fields['Disease'] = predictionResult.status;
      request.fields['Confidence'] = predictionResult.confidence.toString();

      var response = await request.send();

      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        log("Scan stored successfully: ${jsonResponse.toString()}");
        setState(() {
          _requestFailed = false;
        });
      } else {
        log("Error storing scan: ${response.statusCode}");
      }
    } catch (e) {
      log("Storing Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imagePath: image!.path,
                            isImageAsset: false,
                          ),
                        ),
                      );
                    },
                    child: Image.file(image!,
                        height: 300,
                        width: double.maxFinite,
                        fit: BoxFit.cover),
                  ),

                  // While Loading, show a progress indicator
                  if (_isLoading) ...[
                    SizedBox(
                      height: 150,
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],

                  // Show a retry button if request fails in any case
                  if (_requestFailed) ...[
                    const SizedBox(
                      height: 150,
                    ),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 50),
                        const Text("Please try again"),
                        ElevatedButton(
                            child: const Text("Retry"),
                            onPressed: () async {
                              await predictDisease(image);
                            }),
                      ],
                    )),
                  ],

                  // Show results
                  if (!_requestFailed && !_isLoading) ...[
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0),
                      // Start here
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  // "We're ${widget.scan.confidence > 80 ? 'highly' : 'not so'} confident that it is",
                                  "We're ${predictionResult.confidence > 80 ? '' : 'only'}${predictionResult.confidence.round()}% confident that it is",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black45),
                                ),
                                Text(
                                  predictionResult.plant,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Text(
                                  predictionResult.status,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          predictionResult.status == "Healthy"
                                              ? AppColors.success
                                              : AppColors.danger),
                                ),
                              ],
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Column(
                          //     children: [
                          //       Text(
                          //         predictionResult.plant,
                          //         style: const TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 30),
                          //       ),
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           color: predictionResult.status == "Healthy"
                          //               ? AppColors.success.withOpacity(0.8)
                          //               : AppColors.danger.withOpacity(0.8),
                          //           borderRadius: const BorderRadius.all(
                          //               Radius.circular(4)),
                          //         ),
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 4, vertical: 2),
                          //         child: Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             // Icon(
                          //             //   Icons.thumb_up,
                          //             //   color: Colors.white,
                          //             // ),
                          //             SizedBox(
                          //               width: 5,
                          //             ),
                          //             // AnimatedIcon(icon: AnimatedIcons.arrow_menu, progress: ,),
                          //             Text(
                          //               predictionResult.status,
                          //               style: const TextStyle(
                          //                   color: Colors.white, fontSize: 20),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Text(dateFormatter.format(DateTime.now())),
                          //     ],
                          //   ),
                          // ),
                          ...[
                            Padding(
                              // <-- Make sure this is a list of Widgets
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // const Text("DESCRIPTION",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 20)),
                                    // const SizedBox(height: 8),
                                    // Text(
                                    //   "We're ${widget.scan.confidence.toString()}% confident we're giving you the correct prediction👏",
                                    //   style: const TextStyle(fontSize: 16),
                                    // ),
                                    Text(
                                      "ABOUT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      diseaseInfo!.description,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),
                                    const Text("TREATMENT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                      diseaseInfo!.treatment,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),
                                    const Text("PREVENTION",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      diseaseInfo!.prevention,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),

                                    TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.flag,
                                              color: AppColors.danger,
                                              size: 20,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Report Result",
                                              style: TextStyle(
                                                  color: AppColors.danger),
                                            ),
                                          ],
                                        ))
                                    // Text(
                                    //   "We're ${widget.scan.confidence.toString()}% confident we're giving you the correct prediction👏",
                                    //   style: const TextStyle(fontSize: 16),
                                    //   textAlign: TextAlign.center,
                                    // ),
                                    // Text(
                                    //     "If you think this is wrong. You can submit a report here."),
                                    // OutlinedButton(
                                    //   onPressed: () {},
                                    //   child: Text("Submit Report"),
                                    //   style: OutlinedButton.styleFrom(
                                    //     foregroundColor: Colors.red,
                                    //     side: BorderSide(color: Colors.red),
                                    //     shape: RoundedRectangleBorder(
                                    //       side: BorderSide(color: Colors.red),
                                    //       borderRadius: BorderRadius.circular(
                                    //           50), // Adjustable border radius
                                    //     ),
                                    //   ),
                                    // )
                                    // Text(dateFormatter
                                    //     .format(widget.scan.createdAt)),
                                    // const Text("TREATMENT",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 20)),
                                    // const SizedBox(height: 8),
                                    // Text(
                                    //   diseaseInfo!.treatment,
                                    //   style: const TextStyle(fontSize: 16),
                                    // ),
                                    // const SizedBox(height: 20),
                                    // const Text("HOW TO PREVENT?",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 20)),
                                    // const SizedBox(
                                    //   height: 8,
                                    // ),
                                    // Text(
                                    //   diseaseInfo!.prevention,
                                    //   style: const TextStyle(fontSize: 16),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 16,
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(180, 255, 255, 255),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
