import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_waste_app/map.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dining_hall.dart';
import 'login.dart';
import 'package:firebase_database/firebase_database.dart';

class DiningHallPost extends StatefulWidget {
  const DiningHallPost({Key? key}) : super(key: key);

  @override
  _DiningHallPostState createState() => _DiningHallPostState();
}

class _DiningHallPostState extends State<DiningHallPost> {
  final database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    final publisherRef = database.child('publishers/');

    void post(String restaurant_name, int time, double lat, double long,
        String description) async {
      await publisherRef.update({
        restaurant_name + "/time": time,
        restaurant_name + "/lat": lat,
        restaurant_name + "/lon": long,
        restaurant_name + "/description": description,
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Dining Halls Nearby'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: const <Widget>[
            Card(
                child: ListTile(
                    title: Text("College 9/10"),
                    subtitle: Text("leftover pizza, burgers, sandwiches"))),
            Card(
                child: ListTile(
              title: Text("Porter"),
              subtitle: Text("leftover apples"),
            )),
            Card(
                child: ListTile(
              title: Text("Crown"),
              subtitle: Text("leftover coffee"),
            )),
            Card(
                child: ListTile(
              title: Text("Stevenson"),
              subtitle: Text("leftover "),
            ))
          ],
        ));
  }
}
