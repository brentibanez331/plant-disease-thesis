import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:thesis/models/disease.dart";
import "package:thesis/models/scans.dart";
import "package:thesis/services/scan_service.dart";
import "package:thesis/utils/colors.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      appBar: AppBar(title: const Text("Results")),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image(
                      image: NetworkImage(
                          "${dotenv.env['ROOT_DOMAIN']}${widget.scan.imageFilePath}"),
                      height: 300,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.scan.plant,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        widget.scan.diseaseType,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(dateFormatter.format(widget.scan.createdAt)),

                    // FETCHED DESCRIPTION
                    if (diseaseInfo != null) ...[
                      Padding(
                        // <-- Make sure this is a list of Widgets
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("DESCRIPTION",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(diseaseInfo!.description),
                            SizedBox(height: 20),
                            Text("TREATMENT",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(diseaseInfo!.treatment),
                            SizedBox(height: 20),
                            Text("HOW TO PREVENT?",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(diseaseInfo!.prevention),
                          ],
                        ),
                      )
                    ] // <-- Closing bracket for the list
                    else ...[
                      Center(child: CircularProgressIndicator()),
                    ]
                  ],
                ),
              ))),
    );
  }
}
