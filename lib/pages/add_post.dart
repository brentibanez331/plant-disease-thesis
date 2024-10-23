import "dart:io";

import 'package:flutter/material.dart';
import "package:thesis/utils/colors.dart";
import "package:image_picker/image_picker.dart";

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool hasImage = false;
  String? picture;
  File? pictureFile;

  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo == null) {
      return;
    }
    updateSelectedPicture(photo.path);
  }

  void updateSelectedPicture(String path) {
    setState(() {
      picture = path;
      pictureFile = File(path);
      hasImage = true;
    });
  }

  Future<bool> _showExitDialog() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Post?'),
        content: const Text(
          'This will not save your changes.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text(
              'Discard',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // onPopInvokedWithResult: (bool didPop, Object? result) async {
      //   if (didPop) {
      //     return;
      //   }
      //   final result = await _showExitDialog();
      //   if (result && context.mounted) {
      //     Navigator.of(context).pop();
      //   }
      // },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create New Post'),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint("Shared");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Share",
                  style: TextStyle(fontSize: 20, color: AppColors.secondary),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(fontSize: 30)),
                        style: TextStyle(fontSize: 30),
                        maxLines: null,
                        maxLength: 100,
                      ),
                    ),
                    if (hasImage) //convert to image
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.file(pictureFile!),
                      ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Body text(Optional)'),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                color: AppColors.secondary,
                height: 50,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _openGallery,
                        icon: const Icon(
                          Icons.image_outlined,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.camera,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
