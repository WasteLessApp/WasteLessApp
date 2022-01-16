// main.dart
import 'package:flutter/material.dart';
import 'login.dart';

class DiningHall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.black,
        cursorColor: Colors.black,
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.black,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

/* // login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ECORP',
      logo: AssetImage('assets/images/ecorp.png'),
      onLogin: (_) => Future(null),
      onSignup: (_) => Future(null),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: (_) => Future(null),
    );
  }
} */
/* import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login/flutter_login.dart';

class DiningHall extends StatelessWidget {
  const DiningHall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my first app'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.menu),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Home"),
                    ),
                  ],
              onSelected: (item) {
                Navigator.pushNamed(context, '/');
              })
        ],
      ),
      //
    );
  }

  SelectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        print("Taking you to User page");
        break;
      case 2:
        print("Taking you to Dining Hall page");
        break;
    }
  }
}
 */