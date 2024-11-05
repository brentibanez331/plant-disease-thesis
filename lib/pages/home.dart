import 'package:flutter/material.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/widgets/collectionWidgets.dart';
import 'package:thesis/widgets/circleContainerWidgets.dart';
import 'package:thesis/widgets/offerCardWidgets.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/tomato_data.dart';
import 'package:thesis/pages/dashboard.dart';
import 'package:thesis/pages/get_Started.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${widget.user.firstName}' "!",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.account_box_rounded,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.user.username,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 179, 179, 179)),
                  ) //${widget.user.userName}
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              CollectionButton(
                action: [
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStarted(),
                      )),
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStarted(),
                      ))
                ],
                imagePaths: const [
                  'img/homepage.png',
                  'img/homepage.png',
                ],
                mainTexts: const [
                  'Get Started with',
                  'Check our latest',
                ],
                titleTexts: const [
                  'Agronex',
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
              const CircleContainerWidgets(pageContext: [
                CornData(),
                TomatoData(),
                TomatoData(),
                TomatoData(),
                TomatoData(),
              ], imagePaths: [
                'img/corn.jpeg',
                'img/tomato.jpeg',
                'img/potato.png',
                'img/grapes.png',
                'img/apples.png',
              ], foodNames: [
                'Corn',
                'Tomato',
                'Potato',
                'Grapes',
                'Apples',
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
