import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/models/prediction_result.dart";
import "package:thesis/services/plant_predict_service.dart";
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class ScanResultPage extends StatefulWidget {
  final XFile xImage;
  final bool newPrediction;

  const ScanResultPage(
      {Key? key, required this.xImage, this.newPrediction = true})
      : super(key: key);

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  File? image;
  File? scaledImage;
  bool _isLoading = true;
  bool _requestFailed = false;
  late PredictionResult predictionResult;

  @override
  void initState() {
    super.initState();
    image = File(widget.xImage.path);

    if (widget.newPrediction) {
      predictDisease(image);
    }
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

        predictionResult = PredictionResult.fromJson(jsonResponse);

        // Make another API request for the Scan Info Storing
        await storeScanResult();

        log("Response: ${jsonResponse.toString()}");
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
      log("Exception: $e");
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

  Future<void> storeScanResult() async {
    if (predictionResult == null || scaledImage == null) {
      log("Prediction result or scaled image is null");
      return;
    }

    const apiUrl = "http://10.0.2.2:5225/api/scan/add";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

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
        setState(() {
          _requestFailed = true;
        });
      }
    } catch (e) {
      log("Exception: $e");
      setState(() {
        _requestFailed = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                      Text("Status: ${predictionResult.status}")
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
