import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lyncargo/models/Session.dart';
import 'package:lyncargo/ship/ship_list.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  final snackBar = SnackBar(content: Text('Credenciales inválidas'));

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  testcall() async {
    var bytes =
        utf8.encode('${usernameController.text}:${passwordController.text}');
    var base64Credencials = base64.encode(bytes);

    debugPrint(base64Credencials.toString());

    var response = await http.get(
        'https://lyncargocloud.ddns.net/bprestservices/logincliente.rsvc',
        headers: {
          'X-Api-Key': 'CALi10rrcxbjC8DklVO93NMhZwxekwx5zb234ff4f53fdf33yil',
          'X-Bpdominio-Id': 'lce',
          'Authorization': 'Basic $base64Credencials'
        });

    print(response.body);

    if (response.statusCode == 401) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Credenciales inválidas'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    Session session = new Session.fromJson(json.decode(response.body));

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    Provider.of<Session>(context, listen: false).initSession(session);

    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => ShipList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.blue[50],
              Colors.blue[200],
              Colors.blue[300],
              Colors.blue[400],
              Colors.blue[600],
            ])),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Expanded(child: Image.asset('assets/lynlogo.png')),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Usuario')),
              ),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Contraseña')),
              RaisedButton.icon(
                onPressed: () => {testcall()},
                icon: Icon(Icons.arrow_forward_ios),
                label: const Text('Ingresar'),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
