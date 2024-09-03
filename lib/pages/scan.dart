import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thesis/pages/scan_result.dart';
import 'package:thesis/services/camera_service.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/widgets/containerWidgets.dart';

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
    'Lo',
    'Grapes',
    // Add more titles as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Scan Page'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: _openCamera,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              // minimumSize: const Size(20, 100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          child: const Text(
                            "Open Camera",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add some space between the buttons
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: _openGallery,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              // minimumSize: const Size(20, 100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          child: const Text(
                            "Upload Image",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Recent Scans",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: buttonTitles.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 200,
                      child: Card(
                        color: AppColors.primary,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('Tapped Current');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Image(
                                  image: AssetImage("img/leafSample.jpeg"),
                                  height: 100,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(buttonTitles[index]),
                                      const Text("Status: "),
                                      const Text("Aug 28, 10:00 AM"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       Containerwidgets().historyButton(
              //           context,
              //           'img/leafSample.jpeg',
              //           'Tomato Blight',
              //           'Tomato',
              //           160,
              //           200),
              //       Containerwidgets().historyButton(
              //           context,
              //           'img/leafSample.jpeg',
              //           'Banana Blight',
              //           'Tomato',
              //           160,
              //           200),
              //       Containerwidgets().historyButton(
              //           context,
              //           'img/leafSample.jpeg',
              //           'Grape Blight',
              //           'Tomato',
              //           160,
              //           200),
              //       Containerwidgets().historyButton(
              //           context,
              //           'img/leafSample.jpeg',
              //           'Apple Blight',
              //           'Tomato',
              //           160,
              //           200)
              //     ],
              //   ),
              // ),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Previous 30 Days",
                              // style:
                              //     TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.info_outline)
                          ],
                        ),
                        TextButton(
                          child: const Text("View All"),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: buttonTitles.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Card(
                          // style: FilledButton.styleFrom(
                          //     backgroundColor: AppColors.cardBackground),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Tapped Previous');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Image(
                                          image:
                                              AssetImage("img/leafSample.jpeg"),
                                          width: 50,
                                          height: 50),
                                      const SizedBox(width: 10),
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(buttonTitles[index]),
                                          const Text("Status: Blight"),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Text("Aug 24")
                                ],
                              ),
                            ),
                          ),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
