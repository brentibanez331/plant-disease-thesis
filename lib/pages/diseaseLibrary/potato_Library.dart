import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/disease_Info.dart';

class Potatolibrary extends StatefulWidget {
  const Potatolibrary({Key? key}) : super(key: key);

  @override
  _PotatoLibraryState createState() => _PotatoLibraryState();
}

class _PotatoLibraryState extends State<Potatolibrary> {
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
                          "img/diseases_img/Potato/potato_earlyblight.png",
                          "Early Blight",
                          infoWidget(
                              "img/diseases_img/Potato/potato_earlyblight.png",
                              "Early Blight",
                              "Alternaria solani",
                              "Early blight in potatoes is identified by dark brown spots with concentric rings on older leaves, which can lead to yellowing and dieback if untreated. The disease typically thrives in warm temperatures with high humidity levels during the growing season.",
                              "Management includes applying fungicides at regular intervals during periods of high humidity when early blight symptoms first appear on foliage. Resistant potato varieties can also help mitigate this issue effectively.",
                              "Preventative measures involve crop rotation with non-susceptible crops and ensuring proper spacing between plants for improved air circulation to reduce humidity around foliage."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Potato/potato_lateblight.jpg",
                          "Late Blight",
                          infoWidget(
                              "img/diseases_img/Potato/potato_lateblight.jpg",
                              "Late Blight",
                              "Alternaria solani",
                              "Late blight is characterized by large dark green lesions that quickly turn brown on potato leaves; it can lead to rapid plant death if not controlled promptly. This disease thrives under cool temperatures with high humidity .",
                              "Effective management includes immediate application of fungicides once symptoms are observed; however, resistant potato varieties provide a more sustainable solution against late blight .",
                              "To prevent late blight outbreaks, farmers should practice crop rotation with non-host crops and maintain good field sanitation practices ."),
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
