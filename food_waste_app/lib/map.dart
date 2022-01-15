import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

void main() => runApp(const MapAppView());

class MapAppView extends StatelessWidget {
  const MapAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController _controller;
  late LocationData currentLocation;
  late Marker currentLocationMarker;
  Location location = Location();

  LatLng initialPosition = const LatLng(36.977260, -122.050850);

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      body: GoogleMap(
        markers: Set.from(markers),
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: initialPosition, zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          location.onLocationChanged.listen((l) {
            _controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(l.latitude!, l.longitude!), zoom: 15)),
            );
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLoc();
    getData();
  }

  Iterable markers = [];

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    initialPosition =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    location.onLocationChanged.listen((LocationData _currentLocation) {
      setState(() {
        currentLocation = _currentLocation;
        initialPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        markers = [Marker(markerId: MarkerId('1'), position: initialPosition)];
      });
    });
  }

  getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${currentLocation.latitude},${currentLocation.longitude}&radius=1500&type=restaurant&key=API_KEY'));

      final int statusCode = response.statusCode;

      if (statusCode == 201 || statusCode == 200) {
        Map responseBody = json.decode(response.body);
        print(responseBody);
        List results = responseBody["results"];

        Iterable _markers = Iterable.generate(min(10, results.length), (index) {
          Map result = results[index];
          Map location = result["geometry"]["location"];
          LatLng latLngMarker = LatLng(location["lat"], location["lng"]);

          return Marker(
              markerId: MarkerId("marker$index"), position: latLngMarker);
        });

        setState(() {
          markers = _markers;
        });
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
