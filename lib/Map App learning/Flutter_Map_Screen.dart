import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class FlutterMapScreen extends StatefulWidget {
  const FlutterMapScreen({super.key});

  @override
  State<FlutterMapScreen> createState() => _FlutterMapScreenState();
}

class _FlutterMapScreenState extends State<FlutterMapScreen> {
  final MapController mapController = MapController();
  LocationData? currentLocation; // علشان اللوكيشن
  List<LatLng> routePoints = []; //علشان خطوط الطول و دوائر العرض
  List<Marker> markers = []; //علشان لو دست على نقطة يعملى علامة
  /// نبحث على موقع Open route Service علشان ال Api Key
  String ORS_ApiKey =
      "5b3ce3597851110001cf62481fe02358964b4aeeb031bfd30c049723";
  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Map")),
      body:
          currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  initialZoom: 15.0,
                  onTap: (tapPosition, point) {
                    addDestinationMarker(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.example.apps',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(markers: markers),

                  // PolylineLayer(
                  //   polylines: [
                  //     Polyline(
                  //       points: routePoints,
                  //       color: Colors.red,
                  //       strokeWidth: 4,
                  //     ),
                  //   ],
                  // ),
                  if (routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          color: Colors.red,
                          strokeWidth: 4.0,
                        ),
                      ],
                    ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController.move(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              15.0,
            );
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();
    try {
      var Userlocation = await location.getLocation();
      setState(() {
        currentLocation = Userlocation;
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
          ),
        );
      });
    } on Exception {
      currentLocation = null;
    }
    location.onLocationChanged.listen((LocationData newlocation) {
      setState(() {
        currentLocation = newlocation;
      });
    });
  }

  Future<void> getRoute(LatLng destination) async {
    if (currentLocation == null) return;

    final start = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$ORS_ApiKey"
      "&start=${start.longitude},${start.latitude}"
      "&end=${destination.longitude},${destination.latitude}",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["features"] != null && data["features"].isNotEmpty) {
          final List<dynamic> coords =
              data["features"][0]["geometry"]["coordinates"];

  
final summary = data["features"][0]["properties"]["summary"];
        final distanceInKm = summary["distance"] / 1000;
        final durationInMin = summary["duration"] / 60;

          setState(() {
            routePoints =
                coords.map((coord) => LatLng(coord[1], coord[0])).toList();
            markers.clear();
            markers.add(
              Marker(
                width: 80,
                height: 80,
                point: destination,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "المسافة: ${distanceInKm.toStringAsFixed(2)} كم - الوقت: ${durationInMin.toStringAsFixed(1)} دقيقة",
            ),
          ),
        );
          });
        }
      } else {
        print("Failed to fetch route: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  void addDestinationMarker(LatLng point) {
    setState(() {
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: point,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    });
    getRoute(point);
  }
}
