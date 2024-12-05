import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesis/models/post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/pages/edit_post.dart';
import 'package:thesis/services/like_service.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/widgets/fullscreen_image.dart';
import 'package:thesis/pages/post_single.dart';
import 'package:http/http.dart' as http;

class PostItem extends StatefulWidget {
  final Post post;
  final ValueChanged<bool> onLikeToggle;
  final VoidCallback refreshAllData;
  final UserModel user;

  const PostItem(
      {super.key,
      required this.post,
      required this.onLikeToggle,
      required this.refreshAllData,
      required this.user});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool likedPost; // Declare likedPost here
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    likedPost = widget.post.liked; // Initialize it once
  }

  Future<void> deletePost() async {
    try {
      String? token = await storage.read(key: "token");

      final response = await http.delete(
          Uri.parse(
              "${dotenv.env['ROOT_DOMAIN']}/api/post/delete/${widget.post.id}"),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode != 204) {
        debugPrint("Post not Deleted");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your post was successfully removed")),
      );
      widget.refreshAllData();
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account and post details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(widget.post.profileImageUrl),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.post.username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.post.timeDifference,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '⋅',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 25),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '1.2K views',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (widget.user.id == widget.post.userId)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                value: "EditPost",
                                child: Text("Edit"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPostPage(
                                          refreshAllData: widget.refreshAllData,
                                          post: widget.post),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                  value: "DeletePost",
                                  child: Text("Delete"),
                                  onTap: () {
                                    deletePost();
                                  })
                            ];
                          },
                          onSelected: (String value) {
                            print('Selected: $value');
                          },
                        ),
                    ],
                  ),
                ),
                // Comment Post
                //Title
                GestureDetector(
                  onTap: () {
                    navigateToComments(
                        context, widget.user, widget.post, widget.onLikeToggle);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.post.content,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                //Content

                if (widget.post.imageFilePaths.length > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      height: 300,
                      child: ListView.builder(
                          itemCount: widget.post.imageFilePaths.length,
                          padding: EdgeInsets.only(left: 4, right: 4),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final imagePath = widget.post.imageFilePaths[index];
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
                                          widget.post.imageFilePaths.length > 1
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
                // Buttons
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12.0, right: 8, left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: likedPost
                                    ? AppColors.secondary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () async {
                                  setState(() {
                                    likedPost =
                                        !likedPost; // 0 - false, 1 - true
                                    debugPrint(
                                        "BEFORE: ${likedPost.toString()}");
                                  });
                                  widget.onLikeToggle(!likedPost); // false

                                  if (likedPost) {
                                    await LikeService.addLike(widget.post.id);

                                    // if (!success) {
                                    //   setState(() {
                                    //     likedPost = !likedPost;
                                    //     debugPrint(
                                    //         "AFTER: ${likedPost.toString()}");
                                    //   });
                                    //   widget.onLikeToggle(!likedPost);
                                    // }
                                  } else {
                                    await LikeService.removeLike(
                                        widget.post.id);

                                    // if (!success) {
                                    //   setState(() {
                                    //     likedPost = !likedPost;
                                    //     debugPrint(
                                    //         "AFTER: ${likedPost.toString()}");
                                    //   });
                                    //   widget.onLikeToggle(!likedPost);
                                    // }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                          likedPost
                                              ? Icons.thumb_up_alt
                                              : Icons.thumb_up_alt_outlined,
                                          size: 20,
                                          color: likedPost
                                              ? Colors.white
                                              : Colors.black),
                                      SizedBox(width: 4),
                                      Text(
                                        widget.post.noOfLikes.toString(),
                                        style: TextStyle(
                                            color: likedPost
                                                ? Colors.white
                                                : Colors.grey[600],
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(width: 10),
                          Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  navigateToComments(context, widget.user,
                                      widget.post, widget.onLikeToggle);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.chat_outlined,
                                          size: 20, color: Colors.black),
                                      SizedBox(width: 4),
                                      Text(
                                        widget.post.noOfComments.toString(),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {
                                print('Share button pressed');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.share, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1, color: Colors.black12),
      ],
    );
  }
}
