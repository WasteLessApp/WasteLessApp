import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_waste_app/map.dart';
import 'package:food_waste_app/visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'login.dart';
import 'dart:convert';

import 'main.dart';

class DiningHallPost extends StatefulWidget {
  const DiningHallPost({Key? key, required this.buildContext})
      : super(key: key);

  final BuildContext buildContext;

  @override
  _DiningHallPostState createState() => _DiningHallPostState(buildContext);
}

class _DiningHallPostState extends State<DiningHallPost> {
  _DiningHallPostState(this.buildContext);
  final BuildContext buildContext;
  final database = FirebaseDatabase.instance.ref();
  String _displayText = 'default';
  // final _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _load();
  }

  activateListeners() async {}

  String name = "";
  String description = "";
  List<String> restaurantID = [];
  List restaurantDescriptions = [];

  dataMaker() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("publishers/");
    DatabaseEvent event = await ref.once();
    var data = json.decode(json.encode(event.snapshot.value));
    for (String i in restaurantID) {
      if (!restaurantDescriptions.contains(data[i])) {
        restaurantDescriptions.add(data[i]);
      }
    }
  }

  Widget _body = const Center(child: CircularProgressIndicator());

  _load() async {
    // await activateListeners();
    // await dataMaker();

    final database = FirebaseDatabase.instance.ref();
    Stream<DatabaseEvent> _stream = database.onValue;
    _stream.listen((DatabaseEvent event) {
      if (!event.snapshot.exists) {
        database.set('publishers');
      }
    });
    final publisherRef = database.child('publishers/');

    DatabaseEvent event = await publisherRef.once();
    var data = json.decode(json.encode(event.snapshot.value));
    if (data != null) {
      for (String i in data.keys) {
        if (!restaurantDescriptions.contains(data[i])) {
          restaurantDescriptions.add(data[i]);
        }
      }
    }

    Map post(String restaurant_name, int time, double lat, double long,
        String description) {
      var ref = publisherRef.push();
      String key = ref.key!;
      var newRestaurant = <String, dynamic>{
        'restaurant_name': restaurant_name,
        'time': time,
        'lat': lat,
        'long': long,
        'description': description,
        'id': key
      };
      ref.set(newRestaurant);
      return newRestaurant;
    }

    void nestedSetState() {
      final TextEditingController eCtrl1 = TextEditingController();
      final TextEditingController eCtrl2 = TextEditingController();
      ListView listView = ListView.separated(
          primary: false,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: restaurantDescriptions.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    title:
                        Text(restaurantDescriptions[index]['restaurant_name']),
                    subtitle:
                        Text(restaurantDescriptions[index]['description']),
                    onTap: () {
                      Navigator.pushNamed(Main.scaffoldKey.currentContext!,
                          LocationInfo.routeName,
                          arguments: LocationArguments(
                              restaurantDescriptions[index]['id'],
                              restaurantDescriptions[index]['restaurant_name'],
                              restaurantDescriptions[index]['description'],
                              LatLng(restaurantDescriptions[index]['lat'],
                                  restaurantDescriptions[index]['long']),
                              restaurantDescriptions[index]['time'],
                              VisibilityFlag.visible,
                              datapoints: restaurantDescriptions));
                      nestedSetState();
                    }));
          });
      setState(() => _body = Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: eCtrl1,
                  style: const TextStyle(height: 2),
                  decoration: const InputDecoration(
                    hintText: 'Restaurant/Provider Name',
                  ),
                  onChanged: (text) {
                    name = text;
                  },
                ),
                TextField(
                  controller: eCtrl2,
                  style: const TextStyle(height: 2),
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                  onChanged: (text) {
                    description = text;
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Map newRestaurant = post(
                        name,
                        DateTime.now().millisecondsSinceEpoch,
                        MapAppWidgetState.getLat(),
                        MapAppWidgetState.getLon(),
                        description);
                    restaurantID.add(newRestaurant['id']);
                    restaurantDescriptions.add(newRestaurant);
                    print(restaurantDescriptions);
                    eCtrl1.clear();
                    eCtrl2.clear();
                    nestedSetState();
                  },
                  child: const Text('Publish'),
                ),
                listView,
              ],
            ),
          ));
    }

    nestedSetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Publish a Food Alert'),
          centerTitle: true,
        ),
        body: _body);
  }
}
