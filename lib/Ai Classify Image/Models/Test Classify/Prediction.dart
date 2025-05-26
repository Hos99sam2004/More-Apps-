import 'dart:async';
import 'dart:convert';
// import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Prediction_Screen extends StatefulWidget {
  const Prediction_Screen({super.key, required this.ImagePath});
  final File ImagePath;
  @override
  State<Prediction_Screen> createState() => _Prediction_ScreenState();
}

class _Prediction_ScreenState extends State<Prediction_Screen> {
  var data = {};
  bool ServerisLoaded = true;
  // Future<String> GetData() async {  //   var request = await http.MultipartRequest(
  //     'POST'
  //     Uri.parse('http://192.168.1.2:80/image'),
  //   )
  //   request.files.add(
  //     await http.MultipartFile.fromPath('imageData', widget.ImagePath.path),
  //   );
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     return await response.stream.bytesToString();
  //   } else {
  //     print(response.reasonPhrase);
  //     return "";
  //   }
  // }
  Future<String> getData() async {
    print(
      "Image path: ===============================================================  ${widget.ImagePath.path}",
    );
    print("Open getData");
    try {
      print("Stady getData");
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.3:5000/image'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('imageData', widget.ImagePath.path),
      );

      var response = await request.send().timeout(Duration(seconds: 1000));

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        print("Server error: ${response.statusCode}");
        return "";
      }
    } on SocketException {
      print("لم يتم الاتصال بالسيرفر، تحقق من IP أو الشبكة.");
      return "";
    } on TimeoutException {
      print("انتهى وقت الانتظار.");
      return "";
    } catch (e) {
      print("خطأ غير متوقع: $e");
      return "";
    }
  }

  initState() {
    getData().then((value) {
      try {
        if (value.isNotEmpty) {
          final decoded = jsonDecode(value);
          setState(() {
            data = decoded;
            ServerisLoaded = false;
          });
        } else {
          print("⚠️ الرد من السيرفر كان فارغ");
        }
      } catch (e) {
        print("⚠️ خطأ في JSON: $e");
      }
    });

    super.initState();
  }

  Future<void> testConnection() async {
    try {
      var response = await http.get(Uri.parse("http://192.168.1.2:5000/image"));
      print("✅ Response: ${response.body}");
    } catch (e) {
      print("❌ Connection Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: testConnection,
        child: Icon(Icons.refresh, color: Colors.white),
      ),
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(
          "Image Prediction",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
      ),
      body:
          ServerisLoaded
              ? Center(child: CupertinoActivityIndicator())
              : SfCartesianChart(
                primaryXAxis: CategoryAxis(title: AxisTitle(text: "Tages")),
                primaryYAxis: NumericAxis(title: AxisTitle(text: "Prediction")),

                series: [
                  ColumnSeries<SalesData, String>(
                    xValueMapper: (SalesData salesData, _) => salesData.X,
                    yValueMapper: (SalesData salesData, _) => salesData.Y,
                    dataSource: <SalesData>[
                      SalesData(data["class"][0], data["prediction"][0]),
                      SalesData(data["class"][1], data["prediction"][1]),
                    ],
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
    );
  }
}

class SalesData {
  SalesData(this.X, this.Y);
  final String X;
  final double Y;
}
