import "package:flutter_dotenv/flutter_dotenv.dart";

class Post {
  final int id;
  final int userId;
  final String username;
  final String profileImageUrl;
  final String title;
  final String content;
  final int noOfLikes;
  final int noOfComments;
  final DateTime createdAt;
  final String timeDifference;
  final bool liked;

  Post(
      {required this.id,
      required this.userId,
      required this.title,
      required this.username,
      required this.profileImageUrl,
      required this.content,
      required this.noOfLikes,
      required this.noOfComments,
      required this.createdAt,
      required this.liked,
      required this.timeDifference});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        userId: json['userId'] ?? 0,
        username: json['user']['username'] ?? '',
        profileImageUrl: json['user']['profileImageFilePath'] == ''
            ? 'https://placeholder.co/40x40'
            : '${dotenv.env['ROOT_DOMAIN']}${json['user']['profileImageFilePath']}',
        title: json['title'] == '' ? 'Untitled Post' : json['title'],
        content: json['content'] ?? '',
        noOfLikes: json['noOfLikes'] ?? 0,
        noOfComments: json['noOfComments'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
        liked: json['liked'],
        timeDifference: json['timeDifference']);
  }
}
