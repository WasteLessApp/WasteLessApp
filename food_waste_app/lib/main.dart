import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_waste_app/map.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'login.dart';
import 'dining_hall.dart';
import 'dining_hall_post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Home(),
      "/dininghallpost": (context) => DiningHallPost(),
      "/loginpage": (context) => LoginScreen(),
      LocationInfo.routeName: (context) => const LocationInfo(),
    },
    // home: Home(),
  ));

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // subscribe to topic on each app start-up
  await FirebaseMessaging.instance.subscribeToTopic('weather');
  await FirebaseMessaging.instance.unsubscribeFromTopic('weather');
  messaging.getToken().then((token) {
    print(token);
  });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  String? token = await messaging.getToken(
    vapidKey:
        "BObmnLn-ezfeYeUYAVvzxGrk4bqOAL-v2sww_ulMO_iSvNUr6TDwkFlJw0Vc-kCDx-IhJnYTuJhcZlCyW5ucDIc",
  );

  print(Firebase.apps);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print(message.notification?.title);
      print(message.notification?.body);
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
  print(message.notification?.title);
  print(message.notification?.body);
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Waste App'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.menu),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Dining Hall Login"),
                    ),
                  ],
              onSelected: (item) {
                Navigator.pushNamed(context, '/loginpage');
              })
        ],
      ),
      body: MapAppView(buildContext: context),
    );
  }

  SelectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        print("Taking you to Dining Hall page");
        break;
    }
  }
}
