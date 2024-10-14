// Get All scans
// Anything Scan related

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesis/models/scans.dart';
import 'package:http/http.dart' as http;

class ScanService {
  static const storage = FlutterSecureStorage();

  static Future<List<Scan>?> getAllScans(String token, String userId) async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:5225/api/scan/search?userId=$userId"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final scanList = data as List?;

        List<Scan> scans =
            scanList!.map((scan) => Scan.fromJson(scan)).toList();

        return scans;

        // List<Scan> scans = data.map((json) => Scan.fromJson(json)).toList();
      } else {
        log("${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Scan Retrieval Error: $e");
      return null;
    }
  }

  static Future<bool> deleteScan(int scanId) async {
    try {
      String? token = await storage.read(key: "token");

      final response = await http.delete(
          Uri.parse("http://10.0.2.2:5225/api/scan/delete/$scanId"),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode != 204) {
        return false;
      }

      debugPrint("SCAN deleted");
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }
}
