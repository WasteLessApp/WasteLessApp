import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_waste_app/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'visibility.dart';
import 'main.dart';

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
  static late LocationData currentLocation;
  late Marker currentLocationMarker;

  static const String googleCloudAPIKey =
      "AIzaSyA2x4NdZcuV-e99Kru3V1l_Uskq3pqq2wc";
  static int numOfPoints = 10;
  static double radius = 0.05;

  Location location = Location();
  LatLng initialPosition = const LatLng(36.977260, -122.050850);
  Iterable markers = [];

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
        zoomControlsEnabled: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    runMethods();
  }

  activateListeners() async {
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
                  Main.scaffoldKey.currentContext!, LocationInfo.routeName,
                  arguments: LocationArguments(
                      data[key]["id"],
                      name,
                      description,
                      latLngMarker,
                      time,
                      VisibilityFlag.invisible))));
        }
      }

      setState(() {
        markers = Iterable.castFrom(markerList);
      });
    });
  }

  getLocation() async {
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
      });
    });
  }

  runMethods() async {
    await getLocation();
    await activateListeners();
  }

  double getDistance(double lat1, double lon1, double lat2, double lon2) {
    return sqrt(pow(lat1 - lat2, 2) + pow(lon1 - lon2, 2));
  }

  static double getLat() {
    // ignore: unnecessary_null_comparison
    return currentLocation == null ? 0 : currentLocation.latitude!;
  }

  static double getLon() {
    // ignore: unnecessary_null_comparison
    return currentLocation == null ? 0 : currentLocation.longitude!;
  }
}

class LocationArguments {
  final String id;
  final String dhName;
  final String description;
  final LatLng latlong;
  final int time;
  final VisibilityFlag deleteButtonVisible;
  List datapoints = [];

  LocationArguments(this.id, this.dhName, this.description, this.latlong,
      this.time, this.deleteButtonVisible,
      {this.datapoints = const []});
}

class LocationInfo extends StatelessWidget {
  LocationInfo({Key? key}) : super(key: key);

  static const routeName = '/locationInfo';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LocationArguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.dhName),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Text(
                  "Description: \n${args.description}\n\nPosted at ${formatTime(args.time)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ))),
            SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: args.latlong, zoom: 19),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: {
                    Marker(
                        markerId: MarkerId("marker_${args.dhName}"),
                        position: args.latlong)
                  },
                )),
            VisibilityWidget(
              child: TextButton(
                child: Text("Delete"),
                onPressed: () {
                  final database = FirebaseDatabase.instance.ref();
                  final publisherRef = database.child('publishers/');

                  publisherRef.child(args.id).remove();

                  for (int i = 0; i < args.datapoints.length; i++) {
                    if (args.datapoints[i]["id"] == args.id) {
                      args.datapoints.removeAt(i);
                    }
                  }
                  Navigator.pop(context);
                },
              ),
              visibility: args.deleteButtonVisible,
            )
          ],
        )));
    // Center(child: Text(args.description)),
  }

  static String formatTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String amPm = "AM";
    if (hour > 12) {
      hour -= 12;
      amPm = "PM";
    }
    return hour.toString() + ":" + minute.toString() + " " + amPm;
  }
}
