import 'package:flutter/material.dart';
import 'package:thesis/models/post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis/utils/colors.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final ValueChanged<bool> onLikeToggle;

  const PostItem({
    super.key,
    required this.post,
    required this.onLikeToggle,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool likedPost; // Declare likedPost here

  @override
  void initState() {
    super.initState();
    likedPost = widget.post.liked; // Initialize it once
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account and post details
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                              value: "EditPost", child: Text("Edit")),
                          const PopupMenuItem(
                              value: "DeletePost", child: Text("Delete"))
                        ];
                      },
                      onSelected: (String value) {
                        print('Selected: $value');
                      },
                    ),
                  ],
                ),
                // Comment Post
                //Title
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.post.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                //Content
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    widget.post.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Buttons
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
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
                                onTap: () {
                                  setState(() {
                                    likedPost = !likedPost;
                                    debugPrint(likedPost.toString());
                                  });
                                  widget.onLikeToggle(!likedPost);
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
                                  debugPrint("Tapped");
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
    ;
  }
}
