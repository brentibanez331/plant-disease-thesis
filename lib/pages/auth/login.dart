import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/pages/dashboard.dart';
import 'package:thesis/pages/edit_profile.dart';
import 'package:thesis/services/firebase_service.dart';
import 'package:thesis/utils/colors.dart';
import 'package:thesis/pages/library.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  String? _verificationId;
  late UserModel? user;
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
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
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
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
      UserModel? user =
          await FirebaseAuthService.signInWithOTP(_verificationId!, otp);

      setState(() {
        isLoading = false;
      });

      if (user != null) {
        if (user.firstName.isNotEmpty && user.lastName.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(user: user),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(
                user: user,
                isNewUser: true,
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sign in failed. Please try again.")),
          );
        }
      }
    } catch (e) {
      log('OTP verification failed: $e');
    }
  }

  void _showResendOtpSnackBar() {
    const snackBar = SnackBar(
      content: Text("OTP Sent!"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("WELCOME TO",
                      style: TextStyle(
                          color: Color.fromARGB(255, 160, 214, 131),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Padding(padding: EdgeInsets.all(4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/logo.png',
                        width: 50,
                        height: 50,
                      ),
                      const Text(
                        'gronex',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 160, 214, 131)),
                      )
                    ],
                  ),
                  const SizedBox(height: 80
                      //height: MediaQuery.sizeOf(context).height,
                      ),
                  const Text(
                    'Enter your mobile number and\nget started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, height: 0),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center components vertically
                    children: [
                      SizedBox(
                        height: 60,
                        width: 270,
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            hintText: "+639673144235",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                              fontSize:
                                  18, // Adjust the font size for the label
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 20), // Space between TextField and Button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0), // Left and right padding
                        child: SizedBox(
                          width: 170,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _verifyPhoneNumber,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50), // Adjustable border radius
                              ),
                            ),
                            child: isLoading
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : const Text(
                                    "Continue", // Button text
                                    style: TextStyle(
                                      fontSize: 16,
                                    ), // Adjust button text size
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No Internet Access? ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Add your offline logic here
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LibraryPage()));
                              print('Going offline');
                            },
                            child: Text(
                              "Go Offline",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     log("Go To Library");
                      //   },
                      //   child: Text(
                      //     "Go Offline",
                      //     style: TextStyle(
                      //         fontSize: 18, color: AppColors.secondary),
                      //   ),
                      // )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Divider(
                      height:
                          10, // Adjust the height of the divider (including margins)
                      thickness: 1, // Adjust the thickness of the line
                      color: Color.fromRGBO(
                          158, 158, 158, 0.267), // Adjust the color
                      indent: 16, //Add indent to line
                      endIndent: 16, //Add indent to line
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                // Camera icon
                                Icon(
                                  Icons.camera_alt_rounded,
                                  size: 32,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Capture',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Take a picture of your infected leaf')
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                // Camera icon
                                Icon(
                                  Icons.find_in_page,
                                  size: 32,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Determine',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Know the disease through our AI')
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.all(20)),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                // Camera icon
                                Icon(
                                  Icons.eco,
                                  size: 32,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Treat',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Get treatment for your plant')
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                  // const SizedBox(
                  //     height: 20), // Space between Login Box and Resend OTP Box
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[50],
                  //     borderRadius: BorderRadius.circular(15),
                  //     border: Border.all(
                  //       color: Colors.grey,
                  //       width: 1,
                  //     ),
                  //   ),
                  //   width: 350,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       TextButton(
                  //         onPressed:
                  //             _showResendOtpSnackBar, //_resendOtp, // Replace with your function
                  //         child: const Text(
                  //           "Resend OTP",
                  //           style: TextStyle(
                  //               color: Colors.blue,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //       const Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             "New to Agronex?",
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //           TextButton(
                  //             onPressed:
                  //                 null, //_createAccount, // Replace with your function
                  //             child: Text(
                  //               "Register Number",
                  //               style: TextStyle(
                  //                 color: Colors.blue,
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
