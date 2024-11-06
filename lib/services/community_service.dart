import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thesis/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommunityService {
  static Future<List<Post>?> getAllPosts(String token) async {
    try {
      final response = await http
          .get(Uri.parse("${dotenv.env['ROOT_DOMAIN']}/api/post/search"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final postList = data as List?;

        List<Post> posts =
            postList!.map((post) => Post.fromJson(post)).toList();

        return posts;
      } else {
        debugPrint("${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Post Retrieval Error: $e");
      return null;
    }
  }
  // static Future<List<Scan>?> getAllScans(String token, int userId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           "${dotenv.env['ROOT_DOMAIN']}/api/scan/search?userId=$userId"),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $token",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final scanList = data as List?;

  //       List<Scan> scans =
  //           scanList!.map((scan) => Scan.fromJson(scan)).toList();

  //       return scans;

  //       // List<Scan> scans = data.map((json) => Scan.fromJson(json)).toList();
  //     } else {
  //       log("${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     log("Scan Retrieval Error: $e");
  //     return null;
  //   }
  // }
}
