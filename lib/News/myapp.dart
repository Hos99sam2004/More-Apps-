// import 'package:apps/Map%20App%20learning/Flutter_Map_Screen.dart';
// import 'package:apps/Map%20App%20learning/Splash-Screen/Splash_Screen.dart';
import 'package:flutter/material.dart';

class News_App extends StatelessWidget {
  const News_App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "  يزميلى سيبنى فى حالى يزميلى ",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
// api Key = = 3364e8a9dba0443c83c37fd8cb523dde