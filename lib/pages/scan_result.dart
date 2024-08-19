import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/models/prediction_result.dart";
import "package:thesis/services/plant_predict_service.dart";
import 'package:http/http.dart' as http;

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
  bool _isLoading = true;
  bool _requestFailed = false;
  late PredictionResult predictionResult;

  @override
  void initState() {
    super.initState();
    image = File(widget.xImage.path);

    // if (widget.newPrediction) {
    //   predictDisease(image);
    // }
  }

  Future<void> predictDisease(File? image) async {
    setState(() {
      _isLoading = true;
      _requestFailed = false;
    });

    try {
      log("GCP_API URL: ${dotenv.env["GCP_API"]}");
      var request =
          http.MultipartRequest("POST", Uri.parse(dotenv.env["GCP_API"]!));
      request.files.add(await http.MultipartFile.fromPath("fil", image!.path));

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        predictionResult = PredictionResult.fromJson(jsonResponse);

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
      appBar: AppBar(title: Text("Results")),
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
              // if (_isLoading)
              //   Expanded(child: Center(child: CircularProgressIndicator())),

              // // Show a retry button if request fails in any case
              // if (_requestFailed)
              //   Expanded(
              //       child: Center(
              //           child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.warning, color: Colors.red, size: 50),
              //       Text("Please try again"),
              //       ElevatedButton(
              //           child: Text("Retry"),
              //           onPressed: () async {
              //             await predictDisease(image);
              //           }),
              //     ],
              //   ))),

              // // Show results
              // if (!_requestFailed && !_isLoading)
              //   Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("Confidence: ${predictionResult.confidence}"),
              //         Text("Plant: ${predictionResult.plant}"),
              //         Text("Status: ${predictionResult.status}")
              //       ],
              //     ),
              //   ),

              // ------------- IMPORTANT!!! -----------------
              // Build dummy data here for stylings
              // Comment the API request predictDisease() in the initState
              // Comment all elements with conditional renderings
              // Don't forget to update the original result widgets and delete this...
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Confidence: 99.99%"),
                    Text("Plant: Potato"),
                    Text("Status: Northern Leaf Blight")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
