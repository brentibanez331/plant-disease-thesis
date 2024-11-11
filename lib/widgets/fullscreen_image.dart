import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatefulWidget {
  final String imagePath;
  final bool isImageAsset;

  const FullScreenImage(
      {Key? key, required this.imagePath, required this.isImageAsset})
      : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        // Use a Stack to position the close button
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 1)), // True black
                imageProvider: widget.isImageAsset
                    ? AssetImage(widget.imagePath)
                    : NetworkImage(widget.imagePath),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                loadingBuilder: (context, event) =>
                    const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            // Position the close button
            top: 40, // Adjust top padding as needed
            right: 20, // Adjust right padding as needed
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color:
                    Colors.white, // Make the icon white or your preferred color
                size: 30, // Adjust icon size as needed
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
