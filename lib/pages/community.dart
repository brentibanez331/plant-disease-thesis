import 'package:flutter/material.dart';
import 'package:thesis/models/post.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/pages/comments.dart';
import 'package:thesis/pages/add_post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis/widgets/post_item.dart';

class Community extends StatefulWidget {
  final UserModel user;
  final ValueNotifier<List<Post>?> posts;

  const Community({super.key, required this.user, required this.posts});

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  // Track whether the button is liked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 63, 133, 231),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       ClipRRect(
          //         borderRadius: BorderRadius.circular(50), // Match the radius
          //         child: Image(
          //           image: NetworkImage("https://picsum.photos/40"),
          //           // image: NetworkImage(
          //           //     "${dotenv.env['ROOT_DOMAIN']}${widget.user.profileImage}"),
          //           height: 40,
          //           width: 40,
          //           fit: BoxFit.cover, // Adjust the fit as needed
          //         ),
          //       ),
          //       const SizedBox(width: 15),
          //       Expanded(
          //         child: OutlinedButton(
          //           style: OutlinedButton.styleFrom(
          //               side: const BorderSide(color: Colors.black38)),
          //           child: const Align(
          //             alignment:
          //                 Alignment.centerLeft, // Aligns text to the left
          //             child: Text(
          //               "What's on your mind?",
          //               style: TextStyle(color: Colors.black38),
          //             ),
          //           ),
          //           onPressed: () {},
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       IconButton(
          //           onPressed: () {},
          //           icon: const Icon(Icons.photo_album_rounded))
          //     ],
          //   ),
          // ),
          // Container(height: 3, color: Colors.black26),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.posts,
              builder: (context, posts, _) {
                if (posts != null) {
                  if (posts.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final post = widget.posts.value![index];
                          return PostItem(
                            post: post,
                            onLikeToggle: (liked) {
                              final updatedPosts = List<Post>.from(posts);
                              updatedPosts[index] = Post(
                                  // Copy existing post data
                                  id: post.id,
                                  userId: post.userId,
                                  username: post.username,
                                  profileImageUrl: post.profileImageUrl,
                                  title: post.title,
                                  content: post.content,
                                  noOfLikes: liked
                                      ? post.noOfLikes - 1
                                      : post.noOfLikes + 1, // Update like count
                                  noOfComments: post.noOfComments,
                                  createdAt: post.createdAt,
                                  liked: liked,
                                  timeDifference: post.timeDifference,
                                  imageFilePaths: post.imageFilePaths);

                              widget.posts.value = updatedPosts;
                            },
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No posts available."),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
