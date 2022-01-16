import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_waste_app/map.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dining_hall.dart';
import 'login.dart';

class DiningHallPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Card(
            child: ListTile(
                title: Text("Battery Full"),
                subtitle: Text("The battery is full."),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                trailing: Icon(Icons.star))),
        Card(
            child: ListTile(
                title: Text("Anchor"),
                subtitle: Text("Lower the anchor."),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://miro.medium.com/fit/c/64/64/1*WSdkXxKtD8m54-1xp75cqQ.jpeg")),
                trailing: Icon(Icons.star))),
        Card(
            child: ListTile(
                title: Text("Alarm"),
                subtitle: Text("This is the time."),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://miro.medium.com/fit/c/64/64/1*WSdkXxKtD8m54-1xp75cqQ.jpeg")),
                trailing: Icon(Icons.star))),
        Card(
            child: ListTile(
                title: Text("Ballot"),
                subtitle: Text("Cast your vote."),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://miro.medium.com/fit/c/64/64/1*WSdkXxKtD8m54-1xp75cqQ.jpeg")),
                trailing: Icon(Icons.star)))
      ],
    );
  }
}
