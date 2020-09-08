import 'package:flutter/material.dart';
import 'package:lyncargo/login/login.dart';
import 'package:lyncargo/models/Session.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(create: (context) => Session(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'LynCargo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            inputDecorationTheme: InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(20)),
            ),
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.blue, textTheme: ButtonTextTheme.primary)),
        home: Login());
  }
}
