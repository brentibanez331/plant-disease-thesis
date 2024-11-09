import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thesis/pages/diseaseLibrary/corn_Library.dart';
import 'package:thesis/pages/diseaseLibrary/potato_Library.dart';
import 'package:thesis/pages/diseaseLibrary/pepper_bell_Library.dart';
import 'package:thesis/pages/diseaseLibrary/tomato_Library.dart';
import 'package:thesis/pages/diseaseLibrary/grape_Library.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              const Text(
                "Plant Library",
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
                        "img/corn.jpeg", "Corn", const Cornlibrary()),
                    buildImageWithOverlay(
                        "img/apples.png", "Apple", const Potatolibrary()),
                    buildImageWithOverlay(
                        "img/potato_lib.jpg", "Potato", const Potatolibrary()),
                    buildImageWithOverlay(
                        "img/tomato.jpeg", "Tomato", const TomatoLibrary()),
                    buildImageWithOverlay("img/bell_pepper.jpg", "Bell Pepper",
                        const PepperBellLibrary()),
                    buildImageWithOverlay(
                        "img/grapes.png", "Grapes", const GrapeLibrary()),
                  ],
                ),
              ),
            ],
          )),
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
                    style: TextStyle(
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
