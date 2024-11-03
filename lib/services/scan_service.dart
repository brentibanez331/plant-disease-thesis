// Get All scans
// Anything Scan related

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesis/models/disease.dart';
import 'package:thesis/models/scans.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScanService {
  static const storage = FlutterSecureStorage();

  static Future<List<Scan>?> getAllScans(String token, int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${dotenv.env['ROOT_DOMAIN']}/api/scan/search?userId=$userId"),
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
          Uri.parse("${dotenv.env['ROOT_DOMAIN']}/api/scan/delete/$scanId"),
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

  static Future<DiseaseInfo?> getDiseaseInfoFromScan(
      String plant, String disease) async {
    try {
      String? token = await storage.read(key: "token");

      final response = await http.get(
          Uri.parse(
              "${dotenv.env['ROOT_DOMAIN']}/api/disease/search?plant=${plant}&disease=${disease}"),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        DiseaseInfo diseaseInfo = DiseaseInfo.fromJson(data[0]);

        return diseaseInfo;
      } else {
        debugPrint("${response.statusCode}");
      }

      return null;
    } catch (e) {
      debugPrint("Get Disease From Scan FAIL $e");
      return null;
    }
  }
}
