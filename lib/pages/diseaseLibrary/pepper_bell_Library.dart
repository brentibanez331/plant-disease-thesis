import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/disease_Info.dart';

class PepperBellLibrary extends StatefulWidget {
  const PepperBellLibrary({Key? key}) : super(key: key);

  @override
  _PepperBellLibraryState createState() => _PepperBellLibraryState();
}

class _PepperBellLibraryState extends State<PepperBellLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    "Bell Pepper",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    "Learn about bell pepper leaf diseases",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      crossAxisCount: 2,
                      children: [
                        buildImageWithOverlay(
                            "img/diseases_img/Pepper_Bell/pepper_healthy.png",
                            "Healthy Bell Pepper Leaf",
                            infoWidget(
                                "img/diseases_img/Pepper_Bell/pepper_healthy.png",
                                "Healthy Bell Pepper Leaf",
                                "Capsicum annuum",
                                "Healthy bell pepper leaves are simple, oval to lance-shaped, and display a smooth, glossy appearance. The leaves show a uniform dark green color and are thick and leathery in texture. They typically measure 4-8 inches in length with smooth margins and a pointed tip. The leaves have prominent veins that are lighter in color than the leaf blade but still maintain a healthy green hue. When healthy, the leaves stand firm on their petioles and show good turgor pressure. The surface is smooth and waxy, without any blistering or deformities.",
                                "",
                                "")),
                        buildImageWithOverlay(
                            "img/diseases_img/Pepper_Bell/pepper_bacterialspot.jpg",
                            "Bacterial Spot",
                            infoWidget(
                                "img/diseases_img/Pepper_Bell/pepper_bacterialspot.jpg",
                                "Bacterial Spot",
                                "Xanthomonas campestris pv. vesicatoria",
                                "Bacterial spot in pepper bell plants manifests as dark water-soaked lesions on leaves that may develop into holes over time. The lesions can also appear on fruits, leading to significant economic losses if not managed properly.",
                                "Management typically involves applying copper-based bactericides at the onset of symptoms or when conditions favor bacterial spread. Crop rotation with non-host crops helps reduce bacterial populations in the soil.",
                                "Preventive measures include using resistant pepper varieties and maintaining good sanitation practices within the growing area to minimize bacterial spread through tools or equipment.")),
                      ],
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
        ),
      ),
    );
  }

  Widget buildImageWithOverlay(String imagePath, String text, Widget path) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => path),
        );
        log(text);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
