// import 'package:apps/Ai%20Classify%20Image/Test.dart';
// import 'package:apps/Ai%20Classify%20Image/Test.dart' show FruitClassifierPage;
import 'package:apps/Ai%20Classify%20Image/Models/Models%20Test/Test.dart';
import 'package:apps/Ai%20Classify%20Image/Models/Test%20Classify/Classify_Ai.dart';
import 'package:apps/Transitions.dart';
import 'package:flutter/material.dart';

class Homepage_Classify extends StatefulWidget {
  const Homepage_Classify({super.key});

  @override
  State<Homepage_Classify> createState() => _Homepage_ClassifyState();
}

class _Homepage_ClassifyState extends State<Homepage_Classify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        title: Text("Homepage"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            height: 300,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      goto(
                        context,
                        const FruitClassifierPage(),
                        TransitionType.fade,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal.shade400,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      height: double.infinity,
                      // color: Colors.teal.shade600,
                      child: Center(
                        child: Text(
                          "Test Ai Model",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      goto(context, const Classify_Ai(), TransitionType.fade);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal.shade800,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                      height: double.infinity,
                      // color: Colors.teal.shade800,
                      child: Center(
                        child: Text(
                          "AI Classify Image",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
