import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart'; // Assuming this is your color file

class GrapeData extends StatelessWidget {
  const GrapeData({super.key});

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
                  "img/grapes.png",
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
                        'Grapes',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Vitis vinifera)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.subText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(text: "Common Names: "),
                            TextSpan(
                              text: "Wine Grape, Table Grape, European Grape",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n\nGenus: '),
                            TextSpan(
                                text: 'Vitis',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "\nFamily: "),
                            TextSpan(
                                text: "Vitaceae",
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
                                    "Grapes grow on woody vines with large, lobed leaves. "
                                    "The fruit grows in clusters called bunches, containing multiple "
                                    "round or oval berries. The berries can be green, red, purple, "
                                    "or black depending on the variety."),
                            TextSpan(
                                text: "\n\nSize: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Grapevines can grow up to 15-20 meters (50-65 feet) in length. "
                                    "Individual grapes typically measure 1.5-3 cm (0.6-1.2 inches) in diameter."),
                            TextSpan(
                                text: "\n\nGrowth: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Grapevines are climbing plants that use tendrils to attach "
                                    "to supports. They produce flowers in spring and fruits in late "
                                    "summer to early fall. The vines are deciduous, losing their leaves in winter."),
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
