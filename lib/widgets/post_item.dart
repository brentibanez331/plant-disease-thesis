import 'package:flutter/material.dart';
import 'package:thesis/models/post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
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
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Like Button with InkWell for custom highlight
                                SizedBox(
                                  height: 32,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        // isLiked = !isLiked;
                                      });
                                    },
                                    customBorder: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            // isLiked
                                            //     ? Icons.thumb_up_alt
                                            //     :
                                            Icons.thumb_up_alt_outlined,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.post.noOfLikes.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
                                // Comment Button with InkWell for custom highlight
                                SizedBox(
                                  height: 32,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    onTap: () {
                                      // navigateToComments(context);
                                    },
                                    customBorder: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.comment, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.post.noOfComments.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13),
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
        const Divider(thickness: 1),
      ],
    );
    ;
  }
}
