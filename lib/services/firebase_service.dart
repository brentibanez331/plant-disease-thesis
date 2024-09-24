import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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

  static Future<bool> signInWithCredential(
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
        Uri.parse("http://10.0.2.2:5225/api/auth/associate-phone"),
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
            key: "userId", value: (responseData['user']['id']).toString());
        return true;
      } else {
        log("Request failed with status: ${response.statusCode}");
        // Handle unsuccessful response
        return false;
      }
    } catch (e) {
      log("Error in sign in with credential: $e");
      return false;
    }
  }

  static Future<bool> signInWithOTP(
      String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return await signInWithCredential(credential);
  }
}
