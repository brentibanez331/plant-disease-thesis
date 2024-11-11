import 'package:flutter/material.dart';
import 'package:thesis/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const GetStarted(),
    );
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<GetStarted> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome To Agronex',
      description: "Diagnose plant problems quickly and easily!",
      imagePath: 'img/get_started/placeholder.png',
      buttonText: 'Get Started',
    ),
    OnboardingPage(
      title: "Diagnose Your Plant",
      description:
          'Take a Clear Picture of a Diseased Leaf And Upload It.\nOur AI will analyze and suggest potential problems.',
      imagePath: 'img/get_started/placeholder2.png',
      buttonText: 'Next',
    ),
    OnboardingPage(
      title: "Get Treatment Recommendations",
      description:
          "We'll provide tailored advice and treatment options\nbased on your plant's diagnosis.",
      imagePath: 'img/get_started/placeholder3.png',
      buttonText: 'Finish',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pop(context);
      debugPrint('Navigate to main app');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      debugPrint('Skip pressed');
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6, // Adjust this value as needed
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.5, // Adjust this value as needed
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Image.asset(
                            _pages[index].imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        _pages[index].title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _pages[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Bottom navigation section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppColors.secondary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _pages[_currentPage].buttonText,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
  });
}
