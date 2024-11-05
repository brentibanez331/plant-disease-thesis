import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:thesis/models/user.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:thesis/pages/auth/login.dart";
import "package:thesis/pages/edit_profile.dart";

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      // Navigate back to the login screen or any other screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Handle any errors that might occur during sign out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(200), // Match the radius
              child: Image(
                image: NetworkImage(
                    "${dotenv.env['ROOT_DOMAIN']}${widget.user.profileImage}"),
                height: 100,
                width: 100,
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "${widget.user.firstName} ${widget.user.lastName}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.user.phoneNumber,
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 36.0, horizontal: 8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile(
                                  user: widget.user,
                                  isNewUser: false,
                                )),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your Profile", style: TextStyle(fontSize: 16)),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Your Profile");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Settings", style: TextStyle(fontSize: 16)),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Help Center");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Help Center", style: TextStyle(fontSize: 16)),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Privacy Policy");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Privacy Policy",
                              style: TextStyle(fontSize: 16)),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _logout();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Log out", style: TextStyle(fontSize: 16)),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
