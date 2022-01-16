import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class MapAppView extends StatelessWidget {
  const MapAppView({Key? key, required this.buildContext}) : super(key: key);

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapAppWidget(
        buildContext: buildContext,
      ),
    );
  }
}

class MapAppWidget extends StatefulWidget {
  const MapAppWidget({Key? key, required this.buildContext}) : super(key: key);

  final BuildContext buildContext;

  @override
  State<MapAppWidget> createState() => MapAppWidgetState(buildContext);
}

class MapAppWidgetState extends State<MapAppWidget> {
  MapAppWidgetState(this.buildContext);
  String _displayText = 'default';
  final _database = FirebaseDatabase.instance.ref();

  final BuildContext buildContext;

  late GoogleMapController _controller;
  late LocationData currentLocation;
  late Marker currentLocationMarker;

  static const String googleCloudAPIKey =
      "AIzaSyA2x4NdZcuV-e99Kru3V1l_Uskq3pqq2wc";
  static int numOfPoints = 10;
  static double radius = 0.05;

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
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  void _activateListeners() async {
    Stream<DatabaseEvent> stream = _database.child("publishers").onValue;
    stream.listen((DatabaseEvent event) {
      var data = json.decode(json.encode(event.snapshot.value));
      List<Marker> markerList = [];
      for (String key in data.keys) {
        double lat = data[key]["lat"];
        double lon = data[key]["long"];

        if (getDistance(lat, lon, currentLocation.latitude!,
                currentLocation.longitude!) <
            radius) {
          String name = data[key]["restaurant_name"];
          String description = data[key]["description"];
          int time = data[key]["time"];
          LatLng latLngMarker = LatLng(lat, lon);
          markerList.add(Marker(
              markerId: MarkerId("marker_$key"),
              position: latLngMarker,
              onTap: () => Navigator.pushNamed(
                  buildContext, LocationInfo.routeName,
                  arguments: LocationArguments(
                      name, description, latLngMarker, time))));
        }
      }

      for (double i = 0; i < 12; i++) {
        markerList.add(Marker(
            markerId: MarkerId("$i"),
            position: LatLng(
                currentLocation.latitude! + radius * cos(i * 30 * pi / 180),
                currentLocation.longitude! + radius * sin(i * 30 * pi / 180))));
      }

      setState(() {
        markers = Iterable.castFrom(markerList);
      });
    });
  }

  double getDistance(double lat1, double lon1, double lat2, double lon2) {
    return sqrt(pow(lat1 - lat2, 2) + pow(lon1 - lon2, 2));
  }

  //TODO: take data (as dictionary), get distance from current location to each publisher, and add to markers if less than radius

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
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(initialPosition.latitude, initialPosition.longitude),
          zoom: 15)),
    );
    location.onLocationChanged.listen((LocationData _currentLocation) {
      setState(() {
        currentLocation = _currentLocation;
        initialPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        // markers = [Marker(markerId: MarkerId('1'), position: initialPosition)];
      });
    });

    _activateListeners();

    /* try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${initialPosition.latitude},${initialPosition.longitude}&radius=${radius}&type=restaurant&key=${googleCloudAPIKey}'));

      final int statusCode = response.statusCode;

      if (statusCode == 201 || statusCode == 200) {
        Map responseBody = json.decode(response.body);
        List results = responseBody["results"];

        Iterable _markers = Iterable.generate(min(10, results.length), (index) {
          Map result = results[index];
          Map location = result["geometry"]["location"];
          LatLng latLngMarker = LatLng(location["lat"], location["lng"]);

          return Marker(
              markerId: MarkerId("marker$index"),
              position: latLngMarker,
              onTap: () => Navigator.pushNamed(
                  buildContext, LocationInfo.routeName,
                  arguments: LocationArguments(result['name'],
                      result['vicinity'], location['lat'], location['lng'])));
        });

        setState(() {
          markers = _markers;
        });
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      print(e.toString());
    } */
  }
}

class LocationArguments {
  final String dhName;
  final String description;
  final LatLng latlong;
  final int time;

  LocationArguments(this.dhName, this.description, this.latlong, this.time);
}

class LocationInfo extends StatelessWidget {
  const LocationInfo({Key? key}) : super(key: key);

  static const routeName = '/locationInfo';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LocationArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.dhName),
      ),
      body: Center(child: Text(args.description)),
    );
  }
}
