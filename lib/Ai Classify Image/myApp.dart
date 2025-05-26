import 'package:apps/Ai%20Classify%20Image/Presentation/Homepage.dart';
// import 'package:apps/Ai%20Classify%20Image/Splash-Screen/Splash_Screen.dart'show SplashScreen;
import 'package:flutter/material.dart';

class Ai_classify_Image extends StatelessWidget {
  const Ai_classify_Image({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Classify Image',
      color: Colors.white,
      home: const Homepage_Classify(),
    );
  }
}
