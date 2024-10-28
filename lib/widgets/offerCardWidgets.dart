import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart';

class OfferCardWidgets extends StatelessWidget {
  final List<VoidCallback> action; // Correct type
  final List<String> imagePaths;
  final List<String> titles;
  final List<String> subText;

  const OfferCardWidgets({
    super.key,
    required this.action,
    required this.imagePaths,
    required this.titles,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: action[index], // Correctly calls the function
            child: Container(
              width: 350,
              margin: const EdgeInsets.only(right: 16),
              child: Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        imagePaths[index],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titles[index],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            subText[index],
                            style: TextStyle(
                                fontSize: 14, color: AppColors.subText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
