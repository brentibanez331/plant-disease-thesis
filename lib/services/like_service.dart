import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class LikeService {
  static const storage = FlutterSecureStorage();

  static Future<bool> addLike(int userId, int postId) async {
    try {
      String? token = await storage.read(key: "token");

      final response = await http.post(
          Uri.parse(
              "${dotenv.env['ROOT_DOMAIN']}/api/liked-post/add?userId=$userId&postId=$postId"),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode != 200) {
        return false;
      }

      debugPrint("Like added");
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  static Future<bool> removeLike(int userId, int postId) async {
    try {
      String? token = await storage.read(key: "token");

      final response = await http.delete(
          Uri.parse(
              "${dotenv.env['ROOT_DOMAIN']}/api/liked-post/remove?userId=$userId&postId=$postId"),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode != 204) {
        return false;
      }

      debugPrint("Like removed");
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }
}
