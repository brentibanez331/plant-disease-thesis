import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/widgets/fullscreen_image.dart';

Widget infoWidget(String imgPath, String name, String scientificName,
    String description, String treatment, String prevention) {
  return Builder(
    builder: (context) => Scaffold(
      body: Stack(
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
                          imagePath: imgPath,
                          isImageAsset: true,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    imgPath,
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        scientificName,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .subText, // Make sure AppColors.subText is defined correctly
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          children: <TextSpan>[
                            const TextSpan(
                              text: "\nDescription\n\n",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: description),
                            const TextSpan(
                              text: "\n\nTreatment\n\n",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: treatment),
                            const TextSpan(
                              text: "\n\nPrevention\n\n",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: prevention),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
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
      ),
    ),
  );
}
