import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/models/disease_info.dart";
import "package:thesis/models/prediction_result.dart";
import "package:thesis/services/plant_predict_service.dart";
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

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
  static const storage = FlutterSecureStorage();
  late String? token;

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
        await getDiseaseInformation();
        await storeScanResult();
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
            "http://10.0.2.2:5225/api/disease/search?plant=${predictionResult.plant}&disease=${predictionResult.status}"),
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

    const apiUrl = "http://10.0.2.2:5225/api/scan/add";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(await http.MultipartFile.fromPath(
          'Image', scaledImage!.path,
          filename: path.basename(scaledImage!.path)));

      request.fields['UserId'] = "1";
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
      appBar: AppBar(title: const Text("Results")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(image!,
                    height: 200, width: double.maxFinite, fit: BoxFit.cover),
              ),

              // While Loading, show a progress indicator
              if (_isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator())),

              // Show a retry button if request fails in any case
              if (_requestFailed)
                Expanded(
                    child: Center(
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
                ))),

              // Show results
              if (!_requestFailed && !_isLoading)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Confidence: ${predictionResult.confidence}"),
                      Text("Plant: ${predictionResult.plant}"),
                      Text("Status: ${predictionResult.status}"),
                      const SizedBox(height: 20),
                      Text(diseaseInfo.description),
                      Text(diseaseInfo.treatment),
                      Text(diseaseInfo.prevention)
                    ],
                  ),
                ),

              // ------------- IMPORTANT!!! -----------------
              // Build dummy data here for stylings
              // Comment the API request predictDisease() in the initState
              // Comment all elements with conditional renderings
              // Don't forget to update the original result widgets and delete this...
              // const Padding(
              //   padding: EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Confidence: 99.99%"),
              //       Text("Plant: Potato"),
              //       Text("Status: Northern Leaf Blight")
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
