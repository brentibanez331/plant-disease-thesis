import 'dart:developer';

import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesis/models/scans.dart';
import 'package:thesis/pages/home.dart';
import 'package:thesis/pages/scan.dart';
import 'package:thesis/pages/community.dart';
import 'package:thesis/services/scan_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  final storage = const FlutterSecureStorage();
  late String? token;
  late String? userId;

  // final List<Widget> _pages = [
  //   const
  // ];

  final scans = ValueNotifier<List<Scan>?>([]);

  @override
  void initState() {
    getStorageAndFetchData();
    // getAllData();
  }

  void getStorageAndFetchData() async {
    token = await storage.read(key: 'token');
    userId = await storage.read(key: 'userId');
    if (token == null) {
      return;
    }
    getAllData();
  }

  void getAllData() async {
    log("GETTING ALL DATA!!!!!");
    try {
      final fetchedScans = await ScanService.getAllScans(token!, userId!);

      setState(() {
        scans.value = fetchedScans;
      });
    } catch (e) {
      log("[Exception] $e: Error in Retrieving Data");
    }
  }

  void showDialogTrigger() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return (const Text("asdfasdf"));
        });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      // Navigate back to the login screen or any other screen
      Navigator.pushReplacementNamed(context, '/auth/login');
    } catch (e) {
      // Handle any errors that might occur during sign out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: AppBar(
              // automaticallyImplyLeading: false,
              title: const Text("Dashboard"),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'Logout') {
                      _logout();
                    } else if (value == 'Settings') {
                      //_settings();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                          value: "Logout", child: Text("Logout")),
                      const PopupMenuItem(
                          value: "Settings", child: Text("Settings"))
                    ];
                  },
                )
              ]),
          body: IndexedStack(
            index: currentPageIndex,
            children: [
              const HomePage(),
              ScanPage(scans: scans, refreshAllData: getAllData),
              const Community(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              setState(() {
                currentPageIndex = index;
                debugPrint(currentPageIndex.toString());
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                selectedIcon: Icon(Icons.home),
              ),
              NavigationDestination(
                icon: Icon(Icons.camera),
                label: 'Scan',
                selectedIcon: Icon(Icons.camera_outlined),
              ),
              NavigationDestination(
                icon: Icon(Icons.chat),
                label: 'Community',
                selectedIcon: Icon(Icons.chat_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
