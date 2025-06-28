// import 'package:apps/Ai%20Classify%20Image/Presentation/Homepage.dart';
// import 'package:apps/Ai%20Classify%20Image/myApp.dart';
import 'package:apps/Map%20App%20learning/Flutter_Map_Screen.dart';
import 'package:apps/Transitions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Durations.extralong4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade600,
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.blueAccent,
      //   iconSize: 40,
      //   onTap: (value) {
      //     print(value);
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       activeIcon: Icon(Icons.home_outlined),
      //       backgroundColor: Colors.black,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //       // backgroundColor: Colors.black,
      //       activeIcon: Icon(Icons.search_outlined),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //       // backgroundColor: Colors.black,
      //       activeIcon: Icon(Icons.person_outlined),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //       activeIcon: Icon(Icons.settings_outlined),
      //     ),
      //   ],
      // ),
      // // backgroundColor: Colors.black,
      body: _Bulid_UI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var ticker = _controller.forward();
          ticker.whenComplete(() {
            _controller.reset();
            goto(
              context,
              const FlutterMapScreen(),
              TransitionType.combined,
            ); // goto
          });
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _Bulid_UI() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Stack(
        children: [
          // Center(
          //   child: Lottie.asset(
          //     "assets/Animations/Animation - 1747173055960.json",
          //     repeat: true,
          //     width: 250,
          //     height: 250,
          //   ),
          // ),
          Center(
            child: Text(
              "Splash Screen",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Lottie.asset(
              controller: _controller,
              "assets/Animations/Animation - 1747184393299.json",
              repeat: false,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
