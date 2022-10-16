import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lyncargo/models/Session.dart';
import 'package:lyncargo/ship/ship_list.dart';
import 'package:provider/provider.dart';

//Los Stateful widget se usan para widgets que vayan a mutar
//Cuando vayas a cambiar o provocar un re-render del widget
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Los textEditingControllers se usan para manejar la data de los inputs
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  final snackBar = SnackBar(
    content: Text('Credenciales inválidas'),
    duration: Duration(seconds: 3),
  );

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  requestLogin() async {
//El paquete http se usa para hacer requests, obvio, no?
    print('klk');
    var response = await http
        .post(
            'https://634b79d1d90b984a1e3a6809.mockapi.io/api/lyncargo/authenticate')
        .onError((error, stackTrace) {
      print('1');
      print(error.toString());
      print('2');
      return null;
    });

    print(response);
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    Session session = new Session.fromJson(json.decode(response.body));
    Provider.of<Session>(context, listen: false).initSession(session);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShipList()));
  }

//Seguro hay una forma mas inteligente para hacer este gradient :)
  final gradientColors = [
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
  ];

//El metodo build es donde se renderiza el widget
//El widget tree puede ser algo confuso al principio, pero te acostumbras
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors)),
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
              ElevatedButton.icon(
                onPressed: () => requestLogin(),
                icon: const Icon(Icons.arrow_forward_ios),
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
