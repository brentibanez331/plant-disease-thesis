import 'package:flutter/material.dart';

class Containerwidgets {
  Widget historyButton(
    BuildContext context,
    String imgPath,
    String mainText,
    String subText,
    double width,
    double height,
  ) {
    return Container(
      child: InkWell(
        splashColor: const Color.fromARGB(255, 75, 89, 100).withAlpha(30),
        onTap: () {
          debugPrint('Tapped');
        },
        child: SizedBox(
          width: width, //160
          height: height, //200
          child: Padding(
            // Add padding around the entire content
            padding:
                const EdgeInsets.all(5.0), // Ensures equal padding on all sides
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover, // Ensure the image scales properly.
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, left: 3), // Adjust text padding if needed
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      mainText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0), // Consistent text padding
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
