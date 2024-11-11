import 'dart:developer';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesis/models/post.dart';
import 'package:thesis/models/scans.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/pages/home.dart';
import 'package:thesis/pages/library.dart';
import 'package:thesis/pages/profile.dart';
import 'package:thesis/pages/scan.dart';
import 'package:thesis/pages/community.dart';
import 'package:thesis/services/community_service.dart';
import 'package:thesis/services/scan_service.dart';

class Dashboard extends StatefulWidget {
  final UserModel user;

  const Dashboard({super.key, required this.user});

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
  final posts = ValueNotifier<List<Post>?>([]);

  @override
  void initState() {
    getStorageAndFetchData();
    // getAllData();
    super.initState();
  }

  void getStorageAndFetchData() async {
    token = await storage.read(key: 'token');
    if (token == null) {
      return;
    }
    getAllData();
  }

  void getAllData() async {
    log("GETTING ALL DATA!!!!!");
    try {
      final fetchedScans =
          await ScanService.getAllScans(token!, widget.user.id);
      final fetchedPosts = await CommunityService.getAllPosts(token!);

      setState(() {
        scans.value = fetchedScans;
        posts.value = fetchedPosts;
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

  void setPageIndex(int page) {
    setState(() {
      currentPageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text(
      //       "Hi, Brent!",
      //       style: TextStyle(color: Colors.black, fontSize: 24),
      //     ),
      //     foregroundColor: Colors.white,
      //     backgroundColor: Colors.transparent,
      //     actions: [
      //       PopupMenuButton(
      //         onSelected: (value) {
      //           if (value == 'Logout') {
      //             _logout();
      //           } else if (value == 'Settings') {
      //             //_settings();
      //           }
      //         },
      //         icon: const Icon(
      //           Icons.more_vert,
      //           color: Colors.black,
      //         ),
      //         itemBuilder: (BuildContext context) {
      //           return [
      //             const PopupMenuItem(
      //                 value: "Logout", child: Text("Logout")),
      //             const PopupMenuItem(
      //                 value: "Settings", child: Text("Settings"))
      //           ];
      //         },
      //       )
      //     ]),
      body: SafeArea(
        child: IndexedStack(
          index: currentPageIndex,
          children: [
            HomePage(
              user: widget.user,
              setPageIndex: setPageIndex,
            ),
            ScanPage(scans: scans, refreshAllData: getAllData),
            LibraryPage(),
            Community(user: widget.user, posts: posts),
            ProfilePage(user: widget.user)
          ],
        ),
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
            icon: Icon(Icons.book),
            label: 'Library',
            selectedIcon: Icon(Icons.book_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Community',
            selectedIcon: Icon(Icons.chat_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
            selectedIcon: Icon(Icons.person_outlined),
          )
        ],
      ),
    );
  }
}
