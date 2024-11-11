import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thesis/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class PostService {
  static const storage = FlutterSecureStorage();

  // static Future<List<Post>?> getAllScans(String token, int userId) async {
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
