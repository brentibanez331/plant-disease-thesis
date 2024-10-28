import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart'; // Assuming this is your color file

class CornData extends StatelessWidget {
  const CornData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "img/corn.jpeg",
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Corn',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Zea Mays)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .subText, // Make sure AppColors.subText is defined correctly
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(text: "Common Names: "),
                            TextSpan(
                              text: "“Maize”, “Sweet Corn”, “Field Corn”",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n\nGenus: '),
                            TextSpan(
                                text: 'Zea',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "\nSub-Family:"),
                            TextSpan(
                                text: "Panicoideae",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "\n\nDescription",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "\n\nAppearance: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Corn is a tall, leafy plant that grows in upright stalks. "
                                    "Its large, green leaves are long and narrow, growing alternately on the stalk. "
                                    "The plant produces yellow or golden ears, which are covered by "
                                    "tightly wrapped husks that protect the kernels."),
                            TextSpan(
                                text: "\n\nSize: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Corn plants typically grow between 2 to 3 "
                                    "meters (6 to 10 feet) in height, with ears measuring"
                                    "10 to 20 cm (4 to 8 inches) in length. "),
                            TextSpan(
                                text: "\n\nCall: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Corn has two types of flowers: tassels (male) "
                                    "located at the top of the plant, and silks (female) "
                                    "attached to the ears. Pollination occurs through "
                                    "wind dispersal of pollen from tassels to silks. ")
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
    );
  }
}
