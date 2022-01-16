import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_waste_app/map.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dining_hall.dart';
import 'login.dart';
import 'create_post.dart';

class DiningHallPost extends StatefulWidget {
  const DiningHallPost({Key? key}) : super(key: key);

  @override
  _DiningHallPostState createState() => _DiningHallPostState();
}

class _DiningHallPostState extends State<DiningHallPost> {
  final database = FirebaseDatabase.instance.ref();
  final titles = ["Food companies/dining hall names go here"];
  final subtitles = ["Each company description goes here"];
  @override
  Widget build(BuildContext context) {
    final publisherRef = database.child('publishers/');

    void post(String restaurant_name, int time, double lat, double long,
        String description) async {
      final newRestraunt = <String, dynamic>{
        'restaurant_name': restaurant_name,
        'time': time,
        'lat': lat,
        'long': long,
        'description': description,
      };
      return Future(
          () => database.child('publishers/').push().set(newRestraunt));
    }

    post("mcdonalds", DateTime.now().millisecondsSinceEpoch, 37.785834,
        -122.406417, "head to the back we got krabby patties");

    return Scaffold(
        appBar: AppBar(
            title: const Text('Dining Halls Nearby'),
            centerTitle: true,
            actions: [
              PopupMenuButton(
                  icon: const Icon(Icons.menu),
                  itemBuilder: (context) => [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text("Create a Post"),
                        ),
                      ],
                  onSelected: (item) {
                    Navigator.pushNamed(context, '/createpost');
                  })
            ]),
        body: ListView(padding: const EdgeInsets.all(8),
            //getting rid of const for children add back if error thrown
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Description',
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: titles.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      onTap: () {
                        // Navigator.pushNamed(context, '/createpost');
                      },
                      title: Text(titles[index]),
                      subtitle: Text(subtitles[index]),
                    ));
                  })
            ]
            /*
            Card(
                child: ListTile(
                    title: Text("College 9/10"),
                    subtitle: Text("leftover pizza, burgers, sandwiches"))),
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('TextButton'),
                onPressed: () {
                  Navigator.pushNamed(context, '/createpost');
                }),
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
              subtitle: Text("leftover cookies"),
            ))
            */

            ));
  }
}
