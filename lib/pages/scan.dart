import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thesis/models/scans.dart';
import 'package:thesis/pages/all_scans.dart';
import 'package:thesis/pages/scan_previous.dart';
import 'package:thesis/pages/scan_result.dart';
import 'package:thesis/services/camera_service.dart';
import 'package:thesis/services/scan_service.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/widgets/containerWidgets.dart';
import "package:intl/intl.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScanPage extends StatefulWidget {
  final ValueNotifier<List<Scan>?> scans;
  final VoidCallback refreshAllData;

  const ScanPage(
      {super.key, required this.scans, required this.refreshAllData});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? image;
  var dateFormatter = DateFormat('MMM d');
  var dateRecentFormatter = DateFormat('MMM d, h:mm a');

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

  Future<void> _refreshData() async {
    widget.refreshAllData();

    setState(() {});
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
    void _showOptionsDialog(int scanId) async {
      return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select an action",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit'),
                  onTap: () {
                    // Handle edit action
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outlined),
                  title: Text('Delete'),
                  onTap: () async {
                    bool isDeleted = await ScanService.deleteScan(scanId);
                    if (isDeleted) {
                      widget.refreshAllData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Scan deleted successfully!"),
                        ),
                      );
                    } else {}
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share_outlined),
                  title: Text('Share'),
                  onTap: () {
                    // Handle share action
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.report_outlined),
                  title: Text('Report'),
                  onTap: () {
                    // Handle report action
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ));
        },
      );
    }

    return Scaffold(
      // backgroundColor: AppColors.primary,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Detect Plant Disease",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "Scan or upload a plant leaf image to idenfity",
                style: TextStyle(color: Colors.black45),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: ElevatedButton(
                          onPressed: _openCamera,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              // minimumSize: const Size(20, 100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                              ),
                              Text(
                                "Open Camera",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add some space between the buttons
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: ElevatedButton(
                          onPressed: _openGallery,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              // minimumSize: const Size(20, 100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded, size: 40),
                              Text(
                                "Upload Image",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
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
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Recent Scans",
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.info_outline,
                                size: 20, color: Colors.black54)
                          ],
                        ),
                        TextButton(
                          child: const Text("View All"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllScansPage(
                                  scans: widget.scans,
                                  refreshAllData: widget.refreshAllData,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: widget.scans,
                    builder: (context, scans, _) {
                      if (scans != null) {
                        if (scans.isNotEmpty) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: scans.length < 5 ? scans.length : 5,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final scan = widget.scans.value![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScanPreviousPage(scan: scan),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    _showOptionsDialog(scan.id);
                                  },
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          // Apply border radius to the entire card
                                          borderRadius: BorderRadius.circular(
                                              12), // Adjust radius as needed
                                        ),
                                        color: AppColors.primary,
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
                                                        "${dotenv.env['ROOT_DOMAIN']}${scan.imageFilePath}"),
                                                    radius: 25,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // PLANT NAME
                                                      Text(scan.plant,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: scan.diseaseType ==
                                                                      "Healthy"
                                                                  ? AppColors.success
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : AppColors.danger
                                                                      .withOpacity(
                                                                          0.8),
                                                              borderRadius:
                                                                  const BorderRadius.all(
                                                                      Radius.circular(
                                                                          4))),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                  horizontal: 4,
                                                                  vertical: 2),
                                                          child: Text(
                                                              scan.diseaseType,
                                                              style: const TextStyle(color: Colors.white))),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              // Text(dateFormatter
                                              //     .format(scan.createdAt))
                                              Text(scan.daysAgo)
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text("No scans available."),
                          );
                        }
                      } else {
                        // Handle the case where scans is null (e.g., show a loading indicator)
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
