import "dart:convert";
import "dart:developer";
import "dart:io";

import 'package:flutter/material.dart';
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:thesis/models/post.dart";
import "package:thesis/services/camera_service.dart";
import "package:thesis/utils/colors.dart";
import "package:image_picker/image_picker.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "package:thesis/widgets/fullscreen_image.dart";

class EditPostPage extends StatefulWidget {
  final VoidCallback refreshAllData;
  final Post post;
  const EditPostPage(
      {super.key, required this.refreshAllData, required this.post});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPostPage> {
  bool hasImage = false;
  File? pictureFile;
  final List<XFile> _selectedImages = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    titleController.text = widget.post.title;
    contentController.text = widget.post.content;
    super.initState();
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedImages);
      });
    }
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

  Future<Post?> editPost() async {
    try {
      String? token = await storage.read(key: "token");
      String? userId = await storage.read(key: "userId");

      final response = await http.put(
          Uri.parse("${dotenv.env['ROOT_DOMAIN']}/api/post/${widget.post.id}"),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            'Content-Type': 'application/json', // Important for JSON body
          },
          body: jsonEncode({
            "title": titleController.text,
            "content": contentController.text
          }));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body); // Decode the response
        debugPrint("Post updated successfully: ${jsonResponse.toString()}");
        widget.refreshAllData(); // Refresh data after successful update
        if (context.mounted) Navigator.pop(context);
      } else {
        final jsonResponse = jsonDecode(response.body);
        debugPrint(
            "Error updating post: ${jsonResponse['message'] ?? response.statusCode}"); //Print the error message if available.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Error updating post: ${jsonResponse['message'] ?? 'Unknown Error'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final shouldExit = await _showExitDialog();
            if (shouldExit && context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint("Shared");
              editPost();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Update",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: 'Add a title',
                          hintStyle: TextStyle(fontSize: 30)),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                      maxLines: null,
                      maxLength: 100,
                    ),
                  ),
                  if (hasImage)
                    Stack(
                      children: [
                        Container(
                          color: Colors.black, // Solid black background
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            pictureFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(160, 0, 0, 0),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints:
                                  const BoxConstraints(), // Removes default padding
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  hasImage = false;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Body text(Optional)'),
                      maxLines: null,
                    ),
                  ),
                  if (widget.post.imageFilePaths.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: SizedBox(
                        height: 300,
                        child: ListView.builder(
                            itemCount: widget.post.imageFilePaths.length,
                            padding: EdgeInsets.only(left: 4, right: 4),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final imagePath =
                                  widget.post.imageFilePaths[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                        imagePath:
                                            "${dotenv.env['ROOT_DOMAIN']}$imagePath",
                                        isImageAsset: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image(
                                        width:
                                            widget.post.imageFilePaths.length >
                                                    1
                                                ? 250
                                                : 300,
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${dotenv.env['ROOT_DOMAIN']}$imagePath")),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Container(
          //     color: Colors.transparent,
          //     height: 75,
          //     width: double.infinity,
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           IconButton(
          //             onPressed: () {
          //               pickImages();
          //             },
          //             icon: const Icon(
          //               Icons.image_outlined,
          //               size: 30,
          //               color: Colors.black,
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 10,
          //           ),
          //           IconButton(
          //             onPressed: () {
          //               CameraService.pickImageFromCamera();
          //             },
          //             icon: Icon(
          //               Icons.camera_alt_outlined,
          //               size: 30,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //     )),
        ],
      ),
    );
  }
}
