import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis/pages/home.dart';
import 'package:thesis/pages/scan.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ScanPage(),
  ];

  void showDialogTrigger() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return (Text("asdfasdf"));
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
              title: Text("Dashboard"),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'Logout') {
                      _logout();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(value: "Logout", child: Text("Logout"))
                    ];
                  },
                )
              ]),
          body: IndexedStack(
            index: currentPageIndex,
            children: _pages,
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                selectedIcon: Icon(Icons.home),
              ),
              NavigationDestination(icon: Icon(Icons.camera), label: 'Scan')
            ],
          ),
        ),
      ),
    );
  }
}
