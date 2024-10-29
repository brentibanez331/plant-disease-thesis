import 'package:flutter/material.dart';

class CollectionWidgets extends StatefulWidget {
  const CollectionWidgets({super.key});

  @override
  _CollectionWidgetsState createState() => _CollectionWidgetsState();
}

class _CollectionWidgetsState extends State<CollectionWidgets> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(); // This is fine as a placeholder
  }
}

class CollectionButton extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> mainTexts;
  final List<String> titleTexts;

  const CollectionButton({
    super.key,
    required this.imagePaths,
    required this.mainTexts,
    required this.titleTexts,
  });

  @override
  _CollectionButtonState createState() => _CollectionButtonState();
}

class _CollectionButtonState extends State<CollectionButton> {
  int currentImage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.length != widget.mainTexts.length ||
        widget.imagePaths.length != widget.titleTexts.length) {
      throw Exception("All lists must have the same length.");
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) {
                setState(() {
                  currentImage = index;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.imagePaths[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mainTexts[index],
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: 'InriaSerif-Regular',
                            ),
                          ),
                          Text(
                            widget.titleTexts[index],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'InriaSerif-Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Page Indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imagePaths.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentImage == index ? 10 : 6,
                    height: currentImage == index ? 10 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentImage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
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
