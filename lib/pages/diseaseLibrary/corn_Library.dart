import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/disease_Info.dart';

class Cornlibrary extends StatefulWidget {
  const Cornlibrary({Key? key}) : super(key: key);

  @override
  _cornLibraryState createState() => _cornLibraryState();
}

class _cornLibraryState extends State<Cornlibrary> {
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
                    "Corn",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    "Learn about corn leaf diseases",
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
                            "img/diseases_img/Corn/corn_healthy.png",
                            "Healthy Corn Leaf",
                            infoWidget(
                                "img/diseases_img/Corn/corn_healthy.png",
                                "Healthy Corn Leaf",
                                "Zea mays",
                                "Healthy corn leaves exhibit a vibrant deep green to medium green coloration with a distinctive linear-lanceolate shape. The leaves are long, broad, and have prominent parallel veins running lengthwise. A healthy corn leaf typically measures 30-100 cm in length and 5-10 cm in width, with a waxy surface that helps conserve water. The leaf margins are slightly wavy but intact, and the leaf blade is firm and upright. The midrib (central vein) is prominently white to pale green and clearly defined. Leaves emerge from nodes along the stalk in an alternate pattern and maintain their robust structure throughout the growing season.",
                                "",
                                "")),
                        buildImageWithOverlay(
                            "img/diseases_img/Corn/corn_commonrust.jpg",
                            "Common Rust",
                            infoWidget(
                              "img/diseases_img/Corn/corn_commonrust.jpg",
                              "Common Rust",
                              "Puccinia sorghi Pucciniales",
                              "Common rust, caused by the fungus Puccinia sorghi, is characterized by small, elongated to oval-shaped pustules that appear on both surfaces of corn leaves. These pustules start as brick-red and eventually darken to brown or black as they mature, often leading to yellowing and early death of the leaves in severe cases. The disease is most prevalent in cool, moist conditions and can also affect other above-ground parts of the plant, including husks and stalks.",
                              "Management strategies for common rust primarily involve the use of resistant corn hybrids, which significantly reduce the incidence of the disease. If resistant varieties are not available or if infections are severe, fungicide applications may be necessary, especially when 80% of leaves show pustules. Early detection through scouting is crucial for effective fungicide application.",
                              "Preventive measures include planting disease-resistant corn cultivars and avoiding fields with poor air circulation. Timely planting can help minimize exposure to high inoculum levels. Regular monitoring for early signs of rust allows for timely intervention, which is essential in controlling outbreaks.",
                            )),
                        buildImageWithOverlay(
                          "img/diseases_img/Corn/corn_grayleafspot.jpg",
                          "Gray Leaf Spot",
                          infoWidget(
                              "img/diseases_img/Corn/corn_grayleafspot.jpg",
                              "Gray Leaf Spot",
                              "Cercospora zeae-maydis",
                              "Gray leaf spot is caused by the fungus Cercospora zeae-maydis and presents as elongated, gray lesions with dark borders on corn leaves. The lesions can coalesce, leading to significant leaf area loss. This disease typically occurs under warm and humid conditions, making it particularly problematic during wet growing seasons.",
                              "Fungicides can be effective against gray leaf spot if applied early in the disease cycle, particularly when weather conditions are conducive to disease development. Resistant hybrids are also recommended as a primary management strategy to mitigate yield losses associated with this disease.",
                              "Preventive strategies include rotating crops to reduce inoculum levels in the soil and using resistant corn varieties. Maintaining proper plant spacing improves air circulation, which can help reduce humidity levels around the plants and limit disease spread."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Corn/corn_northernleafblight.jpg",
                          "Northern Leaf Blight",
                          infoWidget(
                              "img/diseases_img/Corn/corn_northernleafblight.jpg",
                              "Northern Leaf Blight",
                              "Exserohilum turcicum",
                              "Northern leaf blight is caused by the fungus Exserohilum turcicum and is identified by long, elliptical grayish-green lesions on corn leaves. These lesions can grow significantly in size and may lead to premature leaf death if not managed properly. The disease thrives in humid conditions and can spread rapidly during wet weather.",
                              "Fungicide applications are effective if applied before significant lesion development occurs. Using resistant corn hybrids is also a key strategy in managing northern leaf blight effectively.",
                              "To prevent northern leaf blight, farmers should rotate crops to break the disease cycle and use resistant varieties whenever possible. Monitoring fields for early signs of infection allows for timely fungicide application."),
                        ),
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
