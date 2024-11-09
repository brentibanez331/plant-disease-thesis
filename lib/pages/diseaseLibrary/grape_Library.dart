import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/disease_Info.dart';

class GrapeLibrary extends StatefulWidget {
  const GrapeLibrary({Key? key}) : super(key: key);

  @override
  _grapeLibraryState createState() => _grapeLibraryState();
}

class _grapeLibraryState extends State<GrapeLibrary> {
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
                    "Potato",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    "Learn about plant diseases",
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
                          "img/diseases_img/Grape/grape_leafblight.jpeg",
                          "Leaf Blight",
                          infoWidget(
                            "img/diseases_img/Grape/grape_leafblight.jpeg",
                            "Leaf Blight",
                            "Pseudocercospora vitis",
                            "Healthy grapevines display lush green foliage without any signs of disease or pest damage. The fruit develops uniformly without discoloration or rot, indicating optimal growing conditions.",
                            "For healthy grapevines, treatment focuses on maintaining ideal cultural practices such as proper watering, fertilization, and pest management to prevent diseases from taking hold. Regular inspections help ensure that vines remain healthy throughout their growth cycle.",
                            "Preventive strategies include using disease-resistant grape varieties and implementing integrated pest management practices. Proper sanitation in the vineyard helps minimize potential sources of infection from diseases like black rot.",
                          ),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Grape/grape_blackrot.jpg",
                          "Black Rot",
                          infoWidget(
                            "img/diseases_img/Grape/grape_blackrot.jpg",
                            "Black Rot",
                            "Guignardia bidwellii",
                            "Black rot in grapes is caused by the fungus Guignardia bidwellii, characterized by small black spots on leaves that can expand into larger lesions. Infected berries develop dark brown to black rot spots that eventually cause them to shrivel or fall off. This disease thrives in warm, humid environments.",
                            "Effective treatment includes applying fungicides during critical periods when spores are released and conditions are favorable for infection. Removing infected plant debris from the vineyard helps reduce the inoculum available for future infections.",
                            "Preventive measures involve selecting resistant grape varieties and maintaining good air circulation within the vineyard through proper pruning practices. Regular monitoring for early symptoms allows for timely interventions to prevent widespread infection.",
                          ),
                        )
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => path));
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
