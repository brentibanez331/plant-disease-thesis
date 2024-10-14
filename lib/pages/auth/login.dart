import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/dashboard.dart';
import 'package:thesis/services/firebase_service.dart';
import 'package:thesis/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

  void _showResendOtpSnackBar() {
    final snackBar = const SnackBar(
      content: Text("OTP Sent!"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                width: 350,
                height: 175,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center components vertically
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ), // Left and right padding
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          hintText: "+639673144235",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            fontSize: 18, // Adjust the font size for the label
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Space between TextField and Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Left and right padding
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: _verifyPhoneNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackground,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Adjustable border radius
                            ),
                          ),
                          child: const Text(
                            "Login", // Button text
                            style: TextStyle(
                                fontSize: 16), // Adjust button text size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 20), // Space between Login Box and Resend OTP Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed:
                          _showResendOtpSnackBar, //_resendOtp, // Replace with your function
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New to Agronex?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed:
                              null, //_createAccount, // Replace with your function
                          child: Text(
                            "Register Number",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
