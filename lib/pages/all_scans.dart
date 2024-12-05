import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis/models/scans.dart';
import 'package:thesis/pages/scan_previous.dart';
import 'package:thesis/services/scan_service.dart';
import 'package:thesis/utils/colors.dart';

class AllScansPage extends StatefulWidget {
  final ValueNotifier<List<Scan>?> scans;
  final VoidCallback refreshAllData;
  const AllScansPage(
      {Key? key, required this.scans, required this.refreshAllData})
      : super(key: key);

  @override
  _AllScansState createState() => _AllScansState();
}

class _AllScansState extends State<AllScansPage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "All Previous Scans",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: widget.scans,
                      builder: (context, scans, _) {
                        if (scans != null) {
                          if (scans.isNotEmpty) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: scans.length,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16)),
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                color: scan.diseaseType ==
                                                                        "Healthy"
                                                                    ? AppColors
                                                                        .success
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : AppColors.danger
                                                                        .withOpacity(
                                                                            0.8),
                                                                borderRadius:
                                                                    const BorderRadius.all(
                                                                        Radius.circular(
                                                                            4))),
                                                            padding: const EdgeInsets.symmetric(
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }
                      // child: ListView.builder(itemBuilder: (context, index) {})),
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
