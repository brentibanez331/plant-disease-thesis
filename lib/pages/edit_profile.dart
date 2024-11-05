import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:thesis/models/user.dart";
import "package:thesis/pages/dashboard.dart";
import "package:thesis/utils/colors.dart";
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  final bool isNewUser;

  const EditProfile({Key? key, required this.user, required this.isNewUser})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _image;
  late UserModel updatedUser;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email ?? "";
  }

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

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      String apiUrl =
          "${dotenv.env['ROOT_DOMAIN']}/api/auth/update-user/${widget.user.id}";

      try {
        var request = http.MultipartRequest("PUT", Uri.parse(apiUrl));

        request.headers['Content-Type'] = 'multipart/form-data';

        if (_image != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'Image', _image!.path,
              filename: path.basename(_image!.path)));
        }

        request.fields['FirstName'] = _firstNameController.text;
        request.fields['LastName'] = _lastNameController.text;

        request.fields['Username'] = _usernameController.text;

        if (_emailController.text != "") {
          request.fields['Email'] = _emailController.text;
        }

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        debugPrint("Response body: $responseBody");

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profile Updated Successfully!"),
            backgroundColor: Colors.green, // Change color if needed
          ));

          var jsonResponse = jsonDecode(responseBody);

          updatedUser = UserModel.fromJson(jsonResponse);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard(user: updatedUser)));

          // setState(() {
          //   _requestFailed = false;
          // });
        } else {
          log("Error updating profile: ${response.statusCode}");
        }
      } catch (e) {
        log("Profile Update Exception: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          actions: [
            TextButton(onPressed: () {}, child: const Text("Skip for now"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
          child: Form(
            key: _formKey,
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
                          width: 150,
                          height: 150,
                          color: Colors.black12,
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : widget.user.profileImage != ""
                                  ? Image(
                                      image: NetworkImage(
                                          "${dotenv.env['ROOT_DOMAIN']}${widget.user.profileImage}"),
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Text(
                                        "Upload your Image",
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                          // const Center(
                          //     child: Text(
                          //       "Upload your Image",
                          //       style: TextStyle(fontSize: 16),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: "First Name"),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: "Last Name"),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Username"),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Email (optional)"),
                  validator: (value) {
                    return null;
                  },
                ),
                // SizedBox(height: 20),
                Expanded(child: Container()),
                const Text("By registering, you agree to our Terms of Service"),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
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
          ),
        ));
  }
}
