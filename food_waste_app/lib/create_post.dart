import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePost extends StatelessWidget {
  String company_name = '';
  String company_description = '';
  TextEditingController userInput = TextEditingController();
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
    ));
  }

  Widget buildCompanyName() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Company name',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          /* setState(() {
            company_name = value;
          }); */
        },
      );
}
