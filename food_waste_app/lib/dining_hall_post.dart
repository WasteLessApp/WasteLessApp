import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_waste_app/map.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dining_hall.dart';
import 'login.dart';
import 'create_post.dart';
import 'dart:convert';

class DiningHallPost extends StatefulWidget {
  const DiningHallPost({Key? key}) : super(key: key);

  @override
  _DiningHallPostState createState() => _DiningHallPostState();
}

class _DiningHallPostState extends State<DiningHallPost> {
  final database = FirebaseDatabase.instance.ref();
  String _displayText = 'default';
  // final _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    activateListeners();
  }

  activateListeners() async {
    Stream<DatabaseEvent> stream = database.child("publishers").onValue;
    stream.listen((DatabaseEvent event) {
      var data = json.decode(json.encode(event.snapshot.value));
      // print(data);
    });
  }

  String name = "";
  String description = "";
  List<String> restaurantID = [];
  List<String> restaurantDescriptions = [];
  List<String> dataMaker() {
    List<String> restaurantDescriptions = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref("publishers/");
    for (String i in restaurantID) {
      restaurantDescriptions.add(ref.child(i).once());
    }
    print(restaurantDescriptions);
    return restaurantDescriptions;
  }

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.ref();
    final publisherRef = database.child('publishers/');

    String post(String restaurant_name, int time, double lat, double long,
        String description) {
      final newRestraunt = <String, dynamic>{
        'restaurant_name': restaurant_name,
        'time': time,
        'lat': lat,
        'long': long,
        'description': description,
      };
      return database.child('publishers/').push().set(newRestraunt).toString();
    }

    post("mcdonalds", DateTime.now().millisecondsSinceEpoch, 37.785834,
        -122.406417, "head to the back we got krabby patties");

    final myController = TextEditingController();

    final TextEditingController eCtrl1 = new TextEditingController();
    final TextEditingController eCtrl2 = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publish a Food Alert'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Publish a Food Alert'),
            TextField(
              controller: eCtrl1,
              style: TextStyle(height: 10),
              decoration: InputDecoration(
                hintText: 'Enter Restaurant/Provider Name',
              ),
              onChanged: (text) {
                name = text;
              },
            ),
            TextField(
              controller: eCtrl2,
              style: TextStyle(height: 10),
              decoration: InputDecoration(
                hintText: 'Enter Description',
              ),
              onChanged: (text) {
                description = text;
              },
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                restaurantID.add(post(
                    name,
                    DateTime.now().millisecondsSinceEpoch,
                    MapAppWidgetState.getLat(),
                    MapAppWidgetState.getLon(),
                    description));
                eCtrl1.clear();
                eCtrl2.clear();
              },
              child: Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
