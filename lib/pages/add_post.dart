import "dart:convert";
import "dart:io";

import 'package:flutter/material.dart';
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:thesis/models/post.dart";
import "package:thesis/services/camera_service.dart";
import "package:thesis/utils/colors.dart";
import "package:image_picker/image_picker.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool hasImage = false;
  String? picture;
  File? pictureFile;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  static const storage = FlutterSecureStorage();

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

  Future<Post?> AddPost(String? title, String? content) async {
    try {
      String? token = await storage.read(key: "token");
      String? userId = await storage.read(key: "userId");

      var apiUrl = "${dotenv.env['ROOT_DOMAIN']}/api/scan/add";

      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['Title'] = title!;
      request.fields['Content'] = content!;
      request.fields['UserId'] = userId!;

      var response = await request.send();

      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        debugPrint("Scan stored successfully: ${jsonResponse.toString()}");
      } else {
        debugPrint("Error storing scan: ${response.statusCode}");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
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
                ],
              ),
            ),
          ),
          Container(
              color: Colors.transparent,
              height: 75,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        CameraService.pickImageFromGallery();
                      },
                      icon: const Icon(
                        Icons.image_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        CameraService.pickImageFromCamera();
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
