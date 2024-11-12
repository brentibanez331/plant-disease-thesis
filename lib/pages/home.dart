import 'package:flutter/material.dart';
import 'package:thesis/models/user.dart';
import 'package:thesis/widgets/collectionWidgets.dart';
import 'package:thesis/widgets/circleContainerWidgets.dart';
import 'package:thesis/widgets/offerCardWidgets.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/tomato_data.dart';
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
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Hello, ${widget.user.username}' "!",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.user.firstName + " " + widget.user.lastName,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 179, 179, 179)),
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CollectionButton(
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
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text(
                  "Learn About Diseases",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text(
                  "Check What We Offer!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
