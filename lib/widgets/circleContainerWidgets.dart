import 'package:flutter/material.dart';

class CircleContainerWidgets extends StatelessWidget {
  final List<String> imagePaths;
  final List<String> foodNames;

  const CircleContainerWidgets({
    super.key,
    required this.imagePaths,
    required this.foodNames,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePaths.length != foodNames.length) {
      throw Exception(
          "Image paths and food names lists must be of the same length.");
    }

    return SizedBox(
      height: 130, // Adjust this height based on your needs
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35, // Adjust size as needed
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(imagePaths[index]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    foodNames[index],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
