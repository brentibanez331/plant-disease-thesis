import 'package:flutter/material.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/widgets/collectionWidgets.dart';
import 'package:thesis/widgets/circleContainerWidgets.dart';
import 'package:thesis/widgets/offerCardWidgets.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${widget.user.firstName}' "!",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.account_box_rounded,
                    size: 16,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text("patrickjohn243") //${widget.user.userName}
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const CollectionButton(
                imagePaths: [
                  'img/homepage.png',
                  'img/homepage.png',
                  'img/homepage.png',
                ],
                mainTexts: [
                  'Get Started with',
                  'Check our latest',
                  'Check our latest',
                ],
                titleTexts: [
                  'Agronex',
                  'Updates',
                  'Updates',
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Learn About",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const CircleContainerWidgets(imagePaths: [
                'img/corn.jpeg',
                'img/tomato.jpeg',
                'img/corn.jpeg',
                'img/tomato.jpeg',
                'img/corn.jpeg',
              ], foodNames: [
                'Corn',
                'Tomato',
                'Potato',
                'Grapes',
                'Apple',
              ]),
              const SizedBox(height: 10),
              const Text(
                "Check What We Offer!",
                style: TextStyle(fontSize: 20),
              ),
              const OfferCardWidgets(
                imagePaths: [
                  'img/homepage.png',
                  'img/homepage.png',
                  'img/homepage.png',
                ],
                titles: [
                  'Community Page',
                  'Identify and Treat Diseases',
                  'Special Offer 3',
                ],
                subText: [
                  'Like · Share · Comment',
                  'Picture · Send · Identify',
                  'erer',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
