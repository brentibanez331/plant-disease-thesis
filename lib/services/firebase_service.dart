import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thesis/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const storage = FlutterSecureStorage();

  static Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification code on Android
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent event
        log('Code sent to $phoneNumber');
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
        log('Code auto-retrieval timeout');
      },
    );
  }

  static Future<UserModel?> signInWithCredential(
      PhoneAuthCredential credential) async {
    log("This is getting triggered");
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // You no longer need to retrieve the ID token
    // Remove Firebase ID token retrieval and its usage

    // For postman testing
    log("User Phone Number: ${userCredential.user!.phoneNumber}");

    // Invoke an API request
    try {
      final response = await http.post(
        Uri.parse("${dotenv.env['ROOT_DOMAIN']}/api/auth/associate-phone"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'PhoneNumber': userCredential.user!.phoneNumber ?? '',
        }),
      );

      log("${response.statusCode}");

      if (response.statusCode == 200) {
        log("Request is successful");
        // Show dialog - SUCCESS
        final responseData = jsonDecode(response.body);

        // Handle successful response, such as storing the token or navigating to another screen
        log(responseData['token']);
        await storage.write(key: "token", value: responseData['token']);
        await storage.write(
            key: "userId", value: responseData['user']['id'].toString());
        // await storage.write(
        //     key: "userId", value: (responseData['user']['id']).toString());

        UserModel user = UserModel.fromJson(responseData['user']);
        return user;
      } else {
        log("Request failed with status: ${response.statusCode}");
        // Handle unsuccessful response
        return null;
      }
    } catch (e) {
      log("Error in sign in with credential: $e");
      return null;
    }
  }

  static Future<UserModel?> signInWithOTP(
      String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return await signInWithCredential(credential);
  }
}


// class AuthService{
//   Future<void> storeScanResult() async {
//     if (scaledImage == null) {
//       log("Prediction result or scaled image is null");
//       return;
//     }

//     if (token!.isEmpty) {
//       log("Not authorized");
//       return;
//     }

//     const apiUrl = "http://agronex.somee.com/api/scan/add";

//     try {
//       var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

//       request.headers['Authorization'] = 'Bearer $token';
//       request.headers['Content-Type'] = 'multipart/form-data';

//       request.files.add(await http.MultipartFile.fromPath(
//           'Image', scaledImage!.path,
//           filename: path.basename(scaledImage!.path)));

//       request.fields['UserId'] = "1";
//       request.fields['Plant'] = predictionResult.plant;
//       request.fields['Disease'] = predictionResult.status;
//       request.fields['Confidence'] = predictionResult.confidence.toString();

//       var response = await request.send();

//       if (response.statusCode == 201) {
//         var responseBody = await response.stream.bytesToString();
//         var jsonResponse = jsonDecode(responseBody);

//         log("Scan stored successfully: ${jsonResponse.toString()}");
//         setState(() {
//           _requestFailed = false;
//         });
//       } else {
//         log("Error storing scan: ${response.statusCode}");
//       }
//     } catch (e) {
//       log("Storing Exception: $e");
//     }
//   }
// }