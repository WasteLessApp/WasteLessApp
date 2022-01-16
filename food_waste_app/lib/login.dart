// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dining_hall_post.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.buildContext}) : super(key: key);
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: /* Container(
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.center,
          child:  */
          FlutterLogin(
        //change title name
        //title: 'Dining Hall Login',
        theme: LoginTheme(
          primaryColor: Colors.lightBlue,
          accentColor: Colors.blue,
          titleStyle: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.black,
          ),
          buttonStyle: const TextStyle(
            fontFamily: 'OpenSans',
          ),
          textFieldStyle: const TextStyle(fontFamily: 'NotoSans'),
          bodyStyle: const TextStyle(fontFamily: 'NotoSans'),
        ),
        onLogin: (_) => null,
        // onLogin: (_) => Future(null),
        onSignup: (_) => null,
        // onSignup: (_) => Future(null),
        onSubmitAnimationCompleted: () {
          //Navigator.pushNamed(context, '/dininghallpost');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DiningHallPost(buildContext: buildContext),
          ));
        },
        onRecoverPassword: (_) => null,
        // onRecoverPassword: (_) => Future(null),
      ),
      /* ),
      ), */
    );
  }
}
