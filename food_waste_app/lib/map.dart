import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

// void main() => runApp(const MapAppView());

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

  final BuildContext buildContext;

  late GoogleMapController _controller;
  late LocationData currentLocation;
  late Marker currentLocationMarker;

  static const String googleCloudAPIKey =
      "AIzaSyA2x4NdZcuV-e99Kru3V1l_Uskq3pqq2wc";
  static int numOfPoints = 10;
  static int radius = 2000;

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
          /* location.onLocationChanged.listen((l) {
			_controller.animateCamera(
			  CameraUpdate.newCameraPosition(CameraPosition(
				  target: LatLng(l.latitude!, l.longitude!), zoom: 15)),
			);
		  }); */
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
    // getData();
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

    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${initialPosition.latitude},${initialPosition.longitude}&radius=${radius}&type=restaurant&key=${googleCloudAPIKey}'));

      final int statusCode = response.statusCode;

      if (statusCode == 201 || statusCode == 200) {
        Map responseBody = json.decode(response.body);
        List results = responseBody["results"];

        Iterable _markers = Iterable.generate(min(10, results.length), (index) {
          Map result = results[index];
          print(result);
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
    }
  }
}

class LocationArguments {
  final String dhName;
  final String description;
  final double lat;
  final double lon;

  LocationArguments(this.dhName, this.description, this.lat, this.lon);
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
