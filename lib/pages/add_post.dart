import 'package:flutter/material.dart';
import "package:thesis/utils/colors.dart";

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  bool hasImage = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint("Shared");
              // setState(() {
              //   hasImage = true;
              // });
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
                      padding: EdgeInsets.all(8),
                      child: Image.asset("img/leafSample.jpeg"),
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.image_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
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
    );
  }
}
