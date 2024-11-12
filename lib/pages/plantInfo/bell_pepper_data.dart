import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart'; // Assuming this is your color file

class BellPepperData extends StatelessWidget {
  const BellPepperData({super.key});

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
                  "img/bell_pepper.jpg",
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
                        'Bell Pepper',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Capsicum annuum)',
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
                              text: "Sweet Pepper, Capsicum, Paprika",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n\nGenus: '),
                            TextSpan(
                                text: 'Capsicum',
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
                                    "Bell peppers are bushy plants with dark green leaves. "
                                    "The fruits are large, hollow, and bell-shaped, starting green "
                                    "and ripening to red, yellow, orange, or purple depending on variety. "
                                    "They have a crisp, thick flesh and contain multiple seeds."),
                            TextSpan(
                                text: "\n\nSize: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Plants grow 0.5-1 meter (1.6-3.3 feet) tall. "
                                    "Fruits typically measure 7-12 cm (3-5 inches) in length."),
                            TextSpan(
                                text: "\n\nGrowth: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Bell peppers are warm-season annual plants. They produce "
                                    "small white flowers that develop into fruits. The peppers change "
                                    "color and become sweeter as they ripen on the plant."),
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
