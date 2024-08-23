import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thesis/pages/scan_result.dart';
import 'package:thesis/services/camera_service.dart';
import 'package:thesis/utils/containerWidgets.dart';

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
          builder: (context) => ScanResultPage(xImage: pickedFile),
        ),
      );
    }
  }

  Future<void> _openGallery() async {
    final XFile? pickedFile = await CameraService.pickImageFromGallery();
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPage(xImage: pickedFile),
        ),
      );
    }
  }

  // List of button titles
  final List<String> buttonTitles = [
    'Tomato Blight',
    'Tomato',
    'Lo'
    // Add more titles as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openCamera,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(20, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: const Text(
                      "Open Camera",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add some space between the buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openGallery,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(20, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: const Text(
                      "Upload Image",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            if (image != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.file(image!),
              ),
            const SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    "Newly Saved Images",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Containerwidgets().historyButton(
                      context,
                      'img/leafSample.jpeg',
                      'Tomato Blight',
                      'Tomato',
                      160,
                      200),
                  Containerwidgets().historyButton(
                      context,
                      'img/leafSample.jpeg',
                      'Banana Blight',
                      'Tomato',
                      160,
                      200),
                  Containerwidgets().historyButton(
                      context,
                      'img/leafSample.jpeg',
                      'Grape Blight',
                      'Tomato',
                      160,
                      200),
                  Containerwidgets().historyButton(context,
                      'img/leafSample.jpeg', 'Apple Blight', 'Tomato', 160, 200)
                ],
              ),
            ),
            const SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    "Previous Saved Images",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Containerwidgets().historyButton(
                      context,
                      'img/leafSample.jpeg',
                      'Tomato Blight',
                      'Tomato',
                      120,
                      160),
                  Containerwidgets().historyButton(
                      context,
                      'img/leafSample.jpeg',
                      'Banana Blight',
                      'Tomato',
                      120,
                      160),
                  Containerwidgets().historyButton(
                      context,
                      'img/leafSample.jpeg',
                      'Grape Blight',
                      'Tomato',
                      120,
                      160),
                  Containerwidgets().historyButton(context,
                      'img/leafSample.jpeg', 'Apple Blight', 'Tomato', 120, 160)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
