// import 'package:apps/Map%20App%20learning/Flutter_Map_Screen.dart';
import 'package:apps/Map%20App%20learning/Splash-Screen/Splash_Screen.dart';
import 'package:flutter/material.dart';

class Map_App extends StatelessWidget {
  const Map_App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
