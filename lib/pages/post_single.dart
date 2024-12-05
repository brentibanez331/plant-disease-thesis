import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis/models/post.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/services/like_service.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/widgets/fullscreen_image.dart';

class PostSinglePage extends StatefulWidget {
  final UserModel user;
  final Post post;
  final ValueChanged<bool> onLikeToggle;

  const PostSinglePage(
      {super.key,
      required this.user,
      required this.post,
      required this.onLikeToggle});

  @override
  _PostSingleState createState() => _PostSingleState();
}

class _PostSingleState extends State<PostSinglePage> {
  bool isExpanded = false; // State to track if text is expanded
  bool isLiked = false; // State to track if liked
  late bool likedPost; // Declare likedPost here
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likedPost = widget.post.liked; // Initialize it once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.post.username}'s Post"),
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(widget.post.profileImageUrl),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.post.timeDifference} ⋅ 1.2k views',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.post.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.content,
                  maxLines: isExpanded ? null : 3,
                  style: TextStyle(fontSize: 18),
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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
                                width: widget.post.imageFilePaths.length > 1
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 8, left: 8),
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
                              likedPost = !likedPost; // 0 - false, 1 - true
                              debugPrint("BEFORE: ${likedPost.toString()}");
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
                              await LikeService.removeLike(widget.post.id);

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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Icon(Icons.chat_outlined,
                                    size: 20, color: Colors.black),
                                SizedBox(width: 4),
                                Text(
                                  widget.post.noOfComments.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
          SizedBox(height: 8),
          Container(
            height: 2,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          // Wrap ListView.builder with Expanded
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Limit the number of items to display
              itemBuilder: (BuildContext context, int index) {
                return const Column(
                  children: [Padding(padding: EdgeInsets.all(8)), Text('halo')],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey
                  .withOpacity(0.1), // Optional: Add a background color
              border: Border(
                  top:
                      BorderSide(color: Colors.grey[300]!)), // Add a top border
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none, // Remove default border
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Implement comment submission logic here
                    String commentText = _commentController.text.trim();
                    if (commentText.isNotEmpty) {
                      // Submit the comment
                      print('Submitting comment: $commentText');
                      _commentController.clear(); // Clear the text field

                      // ...  Call your API to submit the comment
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void navigateToComments(BuildContext context, UserModel user, Post post,
    ValueChanged<bool> onLikeToggle) {
  Navigator.of(context).push(_createRoute(user, post, onLikeToggle));
}

Route _createRoute(UserModel user, Post post, ValueChanged<bool> onLikeToggle) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PostSinglePage(
      user: user,
      post: post,
      onLikeToggle: onLikeToggle,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start from the bottom
      const end = Offset(0.0, 0.0); // End at the top
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
