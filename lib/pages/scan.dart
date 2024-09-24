import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thesis/models/scans.dart';
import 'package:thesis/pages/scan_result.dart';
import 'package:thesis/services/camera_service.dart';
import 'package:thesis/services/scan_service.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/widgets/containerWidgets.dart';
import "package:intl/intl.dart";

class ScanPage extends StatefulWidget {
  final ValueNotifier<List<Scan>?> scans;
  final VoidCallback refreshAllData;

  const ScanPage({Key? key, required this.scans, required this.refreshAllData})
      : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? image;
  var dateFormatter = DateFormat('MMM d');

  Future<void> _openCamera() async {
    final XFile? pickedFile = await CameraService.pickImageFromCamera();
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPage(
              xImage: pickedFile, refreshAllData: widget.refreshAllData),
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
          builder: (context) => ScanResultPage(
            xImage: pickedFile,
            refreshAllData: widget.refreshAllData,
          ),
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
              ValueListenableBuilder(
                  valueListenable: widget.scans,
                  builder: (context, scans, _) {
                    if (scans != null) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.scans.value!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final items = widget.scans.value![index];

                            return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Card(
                                  child: GestureDetector(
                                    onTap: () {
                                      debugPrint('Tapped Previous');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "http://10.0.2.2:5225${items.imageFilePath}"),
                                                radius: 35,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(items.plant,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20)),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColors.danger),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 2),
                                                      child: Text(
                                                          "${items.diseaseType}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))),
                                                ],
                                              )
                                            ],
                                          ),
                                          Text(dateFormatter
                                              .format(items.createdAt))
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          });
                    } else {
                      // Handle the case where scans is null (e.g., show a loading indicator)
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
