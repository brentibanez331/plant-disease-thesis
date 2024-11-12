import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart'; // Assuming this is your color file

class PotatoData extends StatelessWidget {
  const PotatoData({super.key});

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
                  "img/potato_lib.jpg",
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
                        'Potato',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Solanum tuberosum)',
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
                              text: "Irish Potato, White Potato, Spud",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n\nGenus: '),
                            TextSpan(
                                text: 'Solanum',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "\nFamily: "),
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
                                    "Potato plants have compound leaves with oval leaflets. "
                                    "They produce small white, pink, or purple flowers. The edible "
                                    "tubers grow underground and can have brown, red, or yellow skin "
                                    "with flesh ranging from white to yellow."),
                            TextSpan(
                                text: "\n\nSize: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Plants grow 0.5-1 meter (1.6-3.3 feet) tall. "
                                    "Tubers typically measure 7.5-10 cm (3-4 inches) in length."),
                            TextSpan(
                                text: "\n\nGrowth: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Potatoes grow from eyes on seed potatoes planted in spring. "
                                    "The tubers develop underground during the growing season and are "
                                    "typically harvested when the plant's foliage dies back."),
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
