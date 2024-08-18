import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlantPredict {
  static Future<void> predictDisease(File? image) async {
    try {
      log("GCP_API URL: ${dotenv.env["GCP_API"]}");
      var request =
          http.MultipartRequest("POST", Uri.parse(dotenv.env["GCP_API"]!));
      request.files.add(await http.MultipartFile.fromPath("file", image!.path));

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log("Response: ${jsonResponse.toString()}");
      } else {
        log("Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Exception: $e");
    }
  }
}
