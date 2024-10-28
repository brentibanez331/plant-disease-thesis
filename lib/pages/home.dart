import 'package:flutter/material.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/widgets/collectionWidgets.dart';
import 'package:thesis/widgets/circleContainerWidgets.dart';
import 'package:thesis/widgets/offerCardWidgets.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/tomato_data.dart';
import 'package:thesis/pages/dashboard.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  final Function(int) setPageIndex;
  const HomePage({super.key, required this.user, required this.setPageIndex});

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
                  Text(
                    "patrickjohn243",
                    style: TextStyle(color: Color.fromARGB(255, 179, 179, 179)),
                  ) //${widget.user.userName}
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
                  'Interact with the',
                ],
                titleTexts: [
                  'Agronex',
                  'Updates',
                  'Community',
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
              const CircleContainerWidgets(pageContext: [
                CornData(),
                TomatoData(),
                CornData(),
                CornData(),
                CornData(),
              ], imagePaths: [
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
              OfferCardWidgets(
                action: [
                  () => widget.setPageIndex(2),
                  () => widget.setPageIndex(1)
                ],
                imagePaths: const [
                  'img/homepage.png',
                  'img/homepage.png',
                ],
                titles: const [
                  'Community Page',
                  'Identify and Treat Diseases',
                ],
                subText: const [
                  'Like · Share · Comment',
                  'Picture · Send · Identify',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
