import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/pages/scan_result.dart";
import "package:thesis/services/camera_service.dart";

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? image;

  Future<void> _openCamera() async {
    final XFile? pickedFile = await CameraService.pickImageFromCamera();
    if (pickedFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanResultPage(xImage: pickedFile)));
    }
  }

  Future<void> _openGallery() async {
    final XFile? pickedFile = await CameraService.pickImageFromGallery();
    if (pickedFile != null) {
      // image = File(pickedFile.path);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanResultPage(xImage: pickedFile)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _openCamera,
                child: Text("Open Camera"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
              )),
          SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _openGallery,
                child: Text("Upload Image"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
              )),
          if (image != null)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.file(image!),
            ),
        ],
      ),
    ));
  }
}
