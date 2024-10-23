import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/utils/colors.dart";

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: () {}, child: const Text("Skip for now"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text('Camera'),
                              onTap: () {
                                _getImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () {
                                _getImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.black12,
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text(
                                  "Upload your Image",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (_image != null)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 60),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: "First Name"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: "Last Name"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Username")),
              const SizedBox(height: 20),
              const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Email (optional)")),
              // SizedBox(height: 20),
              Expanded(child: Container()),
              const Text("By registering, you agree to our Terms of Service"),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("DONE"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50), // Adjustable border radius
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
