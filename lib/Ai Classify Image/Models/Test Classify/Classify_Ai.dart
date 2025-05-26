import 'dart:io';
import 'package:apps/Ai%20Classify%20Image/Models/Test%20Classify/Prediction.dart';
import 'package:apps/Transitions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Classify_Ai extends StatefulWidget {
  const Classify_Ai({super.key});

  @override
  State<Classify_Ai> createState() => _Classify_AiState();
}

class _Classify_AiState extends State<Classify_Ai> {
  late ImageProvider selectedImage;
  bool isImageSelected = false;
  File? ImagePath;
  Future<void> pickAndImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = FileImage(File(picked.path));
        isImageSelected = true;
        ImagePath = File(picked.path);
        print(
          "Image path: ===============================================================  ${ImagePath!.path}",
        );
      });
    }
  }

  Future<void> pickAndImageFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        selectedImage = FileImage(File(picked.path));
        isImageSelected = true;
        ImagePath = File(picked.path);
        print(
          "Image path: ===============================================================  ${ImagePath!.path}",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text("Classify Ai", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.greenAccent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 300,
                // padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 5),
                ),
                child:
                    isImageSelected
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(image: selectedImage, fit: BoxFit.fill),
                        )
                        : Center(
                          child: Text(
                            " Classify Ai ... \n Image not selected yet!! ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
              ),
            ),
            SizedBox(height: 20),
            !isImageSelected
                ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      ElevatedButton(
                        onPressed: pickAndImageFromCamera,
                        child: Text(
                          " Capture Image from Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(160, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: pickAndImageFromGallery,
                        child: const Text(
                          "Load Image from Gallery ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(160, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => goto(
                              context,
                              Prediction_Screen(ImagePath: ImagePath!),
                              TransitionType.rotation,
                            ),
                        child: Text(
                          " Predict Image ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(160, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isImageSelected = false;
                            pickAndImageFromGallery();
                          });
                        },
                        child: const Text(
                          " Select Another Image",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(160, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
