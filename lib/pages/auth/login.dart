import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/dashboard.dart';
import 'package:thesis/services/firebase_service.dart';
import 'package:thesis/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  String? _verificationId;

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = "+639673144235";
    log("Build initialized");
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    FirebaseAuthService.verifyPhoneNumber(
      phoneNumberController.text,
      onCodeSent: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
        log('OTP code sent successfully');
        _showOtpDialog();
      },
      onVerificationFailed: (String errorMessage) {
        log('Verification failed: $errorMessage');
      },
    );
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController otpController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String otp = otpController.text;
                if (_verificationId != null) {
                  await _signInWithOtp(otp);
                }
                // Navigator.of(context).pop();
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithOtp(String otp) async {
    try {
      Navigator.of(context).pop();
      bool success =
          await FirebaseAuthService.signInWithOTP(_verificationId!, otp);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      }
    } catch (e) {
      log('OTP verification failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Login",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  hintText: "+639673144235",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: "Phone Number",
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: const Text("Verify"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
