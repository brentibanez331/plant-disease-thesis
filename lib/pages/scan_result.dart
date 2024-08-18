import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/services/plant_predict_service.dart";

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

  @override
  void initState() {
    super.initState();
    image = File(widget.xImage.path);

    if (widget.newPrediction) {
      PlantPredict.predictDisease(image);
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(image!,
                    height: 200, width: double.maxFinite, fit: BoxFit.cover),
              ),
              Expanded(child: Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      ),
    );
  }
}
