import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis/pages/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis/pages/game/blockblast.dart';
import 'package:thesis/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Set status bar color to white
    statusBarIconBrightness:
        Brightness.dark, // Set status bar icons to dark (black)
    statusBarBrightness: Brightness.light, // For iOS, set status bar to light
  ));

  // Flame.device.fullScreen();
  BlockGame game = BlockGame();
  runApp(GameWidget(
    game: kDebugMode ? BlockGame() : game,
    backgroundBuilder: (context) {
      return Container(color: AppColors.secondary);
    },
  ));
  // runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      // home: Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
