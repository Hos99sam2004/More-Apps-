import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FruitClassifierPage extends StatefulWidget {
  const FruitClassifierPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _FruitClassifierPageState createState() => _FruitClassifierPageState();
}

class _FruitClassifierPageState extends State<FruitClassifierPage> {
  late Interpreter _interpreter;
  final ImagePicker _picker = ImagePicker();
  String _result = 'لم يتم الاختبار بعد';
  File? _image;
  List<double> _probabilities = [];

  static const int _inputSize = 180;
  static const List<String> _labels = [
    'apple',
    'banana',
    'beetroot',
    'bell pepper',
    'cabbage',
    'capsicum',
    'carrot',
    'cauliflower',
    'chilli pepper',
    'corn',
    'cucumber',
    'eggplant',
    'garlic',
    'ginger',
    'grapes',
    'jalepeno',
    'kiwi',
    'lemon',
    'lettuce',
    'mango',
    'onion',
    'orange',
    'paprika',
    'pear',
    'peas',
    'pineapple',
    'pomegranate',
    'potato',
    'raddish',
    'soy beans',
    'spinach',
    'sweetcorn',
    'sweetpotato',
    'tomato',
    'turnip',
    'watermelon',
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/Ai_models/fruit_model.tflite',
    );
  }

  Future<Uint8List> _preprocessImage(XFile pickedFile) async {
    final bytes = await pickedFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: _inputSize,
      targetHeight: _inputSize,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    // final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawUnmodified,
    );

    if (byteData == null) {
      throw Exception("تعذر تحويل الصورة إلى ByteData");
    }

    return byteData.buffer.asUint8List();
  }

  Future<void> _predictImage(XFile pickedFile) async {
    final rgbaBytes = await _preprocessImage(pickedFile);

    final input = Float32List(_inputSize * _inputSize * 3);
    for (int i = 0, j = 0; i < rgbaBytes.length; i += 4) {
      final r = rgbaBytes[i].toDouble();
      final g = rgbaBytes[i + 1].toDouble();
      final b = rgbaBytes[i + 2].toDouble();
      final a = rgbaBytes[i + 3].toDouble();

      if (a == 0) {
        input[j++] = 1.0;
        input[j++] = 1.0;
        input[j++] = 1.0;
      } else {
        input[j++] = r / 255.0;
        input[j++] = g / 255.0;
        input[j++] = b / 255.0;
      }
    }

    final inputTensor = input.reshape([1, _inputSize, _inputSize, 3]);
    final outputShape = _interpreter.getOutputTensor(0).shape;
    final output = List.filled(
      outputShape.reduce((a, b) => a * b),
      0.0,
    ).reshape(outputShape);

    _interpreter.run(inputTensor, output);

    final probs = List<double>.from(output[0]);
    int maxIndex = 0;
    double maxProb = probs[0];
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > maxProb) {
        maxProb = probs[i];
        maxIndex = i;
      }
    }

    setState(() {
      _result =
          'التنبؤ: ${_labels[maxIndex]} (ثقة ${(maxProb * 100).toStringAsFixed(1)}%)';
      _probabilities = probs;
      print("Input size: $_inputSize");
      print("Result: $_result");
      print("Probabilities: $_probabilities");
    });

    // Debugging
    print("Top Predictions:");
    for (int i = 0; i < probs.length; i++) {
      print('${_labels[i]}: ${(probs[i] * 100).toStringAsFixed(2)}%');
    }
  }

  Future<void> _pickAndPredict() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
      await _predictImage(picked);
      print('Picked file path: ${picked.path}');
    }
  }

  List<BarChartGroupData> makeBarData(List<double> probs, List<String> labels) {
    // تأكد أن طول القائمتين متساوي
    if (probs.length != labels.length) {
      throw ArgumentError('عدد القيم يجب أن يساوي عدد التسميات');
    }

    // استخراج أعلى 5 نتائج
    final topResults = List.generate(
      probs.length,
      (i) => MapEntry(labels[i], probs[i]),
    )..sort((a, b) => b.value.compareTo(a.value));

    final top5 = topResults.take(5).toList();

    return List.generate(top5.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: top5[index].value * 100, // تحويل من نسبة (0-1) إلى (0-100)
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 18,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تصنيف الفاكهة'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 15),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child:
                  _image == null
                      ? const Text(
                        'لم تختَر صورة بعد',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          // height: 200,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _result,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text(
                'اختر صورة من المعرض',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: _pickAndPredict,
            ),
            const SizedBox(height: 39),
            if (_probabilities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barGroups: makeBarData(_probabilities, _labels),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= 5) return Container();
                              final topLabels = List.generate(
                                _probabilities.length,
                                (i) => MapEntry(_labels[i], _probabilities[i]),
                              )..sort((a, b) => b.value.compareTo(a.value));
                              return Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  topLabels[value.toInt()].key,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
