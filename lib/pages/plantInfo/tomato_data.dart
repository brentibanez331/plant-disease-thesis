import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart'; // Assuming this is your color file

class TomatoData extends StatelessWidget {
  const TomatoData({super.key});

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
                  "img/tomato.jpeg",
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
                        'Tomato',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Solanum lycopersicum)',
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
                              text: "“Tomato” , “Garden Tomato”",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n\nGenus: '),
                            TextSpan(
                                text: 'Solanum',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "\nSub-Family:"),
                            TextSpan(
                                text: "Solanaceae",
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
                                    "Tomatoes are widely cultivated for their edible, often red fruits, "
                                    "which are consumed raw or cooked in many dishes worldwide. "
                                    "The tomato plant is a sprawling, leafy plant with a vine-like growth habit. "
                                    "Its fruits vary in color, size, and flavor, depending on the variety."),
                            TextSpan(
                                text: "\n\nSize: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "Tomato plants can reach a height of 1-3 "
                                    "meters (3-10 feet), depending on the cultivar and "
                                    "growing conditions. "),
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
