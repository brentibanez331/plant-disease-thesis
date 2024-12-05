import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:thesis/models/disease.dart";
import "package:thesis/models/scans.dart";
import "package:thesis/services/scan_service.dart";
import "package:thesis/utils/colors.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:thesis/widgets/fullscreen_image.dart";

class ScanPreviousPage extends StatefulWidget {
  final Scan scan;

  const ScanPreviousPage({Key? key, required this.scan}) : super(key: key);

  @override
  _ScanPreviousState createState() => _ScanPreviousState();
}

class _ScanPreviousState extends State<ScanPreviousPage> {
  DiseaseInfo? diseaseInfo;
  var dateFormatter = DateFormat('MMM d, h:mm a');

  @override
  void initState() {
    super.initState();

    _fetchDiseaseInfo();
  }

  Future<void> _fetchDiseaseInfo() async {
    DiseaseInfo? fetchedInfo = await ScanService.getDiseaseInfoFromScan(
        widget.scan.plant, widget.scan.diseaseType);

    // Update the state only after fetching
    setState(() {
      diseaseInfo = fetchedInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imagePath:
                              "${dotenv.env['ROOT_DOMAIN']}${widget.scan.imageFilePath}",
                          isImageAsset: false,
                        ),
                      ),
                    );
                  },
                  child: Image(
                    image: NetworkImage(
                        "${dotenv.env['ROOT_DOMAIN']}${widget.scan.imageFilePath}"),
                    height: 300,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              // "We're ${widget.scan.confidence > 80 ? 'highly' : 'not so'} confident that it is",
                              "We're ${widget.scan.confidence > 80 ? '' : 'only'}${widget.scan.confidence.round()}% confident that it is",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black45),
                            ),
                            Text(
                              widget.scan.plant,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Text(
                              widget.scan.diseaseType,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: widget.scan.diseaseType == "Healthy"
                                      ? AppColors.success
                                      : AppColors.danger),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 5),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: widget.scan.diseaseType == "Healthy"
                      //         ? AppColors.success.withOpacity(0.8)
                      //         : AppColors.danger.withOpacity(0.8),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(4)),
                      //   ),
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 4, vertical: 2),
                      //   child: Text(
                      //     "${widget.scan.diseaseType}",
                      //     style: const TextStyle(
                      //         color: Colors.white, fontSize: 20),
                      //   ),
                      // ),

                      // FETCHED DESCRIPTION
                      if (diseaseInfo != null) ...[
                        Padding(
                          // <-- Make sure this is a list of Widgets
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                // const Text("DESCRIPTION",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20)),
                                // const SizedBox(height: 8),
                                // Text(
                                //   "We're ${widget.scan.confidence.toString()}% confident we're giving you the correct prediction👏",
                                //   style: const TextStyle(fontSize: 16),
                                // ),
                                Text(
                                  "ABOUT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  diseaseInfo!.description,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                if (widget.scan.diseaseType != "Healthy") ...[
                                  const SizedBox(height: 30),
                                  const Text("TREATMENT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(
                                    diseaseInfo!.treatment,
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  const Text("PREVENTION",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    diseaseInfo!.prevention,
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],

                                SizedBox(height: 50),
                                Text(
                                    "Scanned on ${dateFormatter.format(widget.scan.createdAt)}"),

                                TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: AppColors.danger,
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Report Result",
                                          style: TextStyle(
                                              color: AppColors.danger),
                                        ),
                                      ],
                                    ))
                                // Text(
                                //   "We're ${widget.scan.confidence.toString()}% confident we're giving you the correct prediction👏",
                                //   style: const TextStyle(fontSize: 16),
                                //   textAlign: TextAlign.center,
                                // ),
                                // Text(
                                //     "If you think this is wrong. You can submit a report here."),
                                // OutlinedButton(
                                //   onPressed: () {},
                                //   child: Text("Submit Report"),
                                //   style: OutlinedButton.styleFrom(
                                //     foregroundColor: Colors.red,
                                //     side: BorderSide(color: Colors.red),
                                //     shape: RoundedRectangleBorder(
                                //       side: BorderSide(color: Colors.red),
                                //       borderRadius: BorderRadius.circular(
                                //           50), // Adjustable border radius
                                //     ),
                                //   ),
                                // )
                                // Text(dateFormatter
                                //     .format(widget.scan.createdAt)),
                                // const Text("TREATMENT",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20)),
                                // const SizedBox(height: 8),
                                // Text(
                                //   diseaseInfo!.treatment,
                                //   style: const TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(height: 20),
                                // const Text("HOW TO PREVENT?",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20)),
                                // const SizedBox(
                                //   height: 8,
                                // ),
                                // Text(
                                //   diseaseInfo!.prevention,
                                //   style: const TextStyle(fontSize: 16),
                                // ),
                              ],
                            ),
                          ),
                        )
                      ] // <-- Closing bracket for the list
                      else ...[
                        const Center(child: CircularProgressIndicator()),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 16,
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(180, 255, 255, 255),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
