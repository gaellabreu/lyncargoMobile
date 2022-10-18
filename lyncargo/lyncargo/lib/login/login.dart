import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lyncargo/models/Session.dart';
import 'package:lyncargo/ship/ship_list.dart';
import 'package:provider/provider.dart';

//Los Stateful widget se usan para widgets que vayan a mutar
//Cuando vayas a cambiar o provocar un re-render del widget
//hay auto complete para esto, si escribes "st" seguro te pone el auto complete para statefull y stateless.
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Los textEditingControllers se usan para manejar la data de los inputs
  //Esto solo es bueno cuando tienes pocos inputs en una pantalla y quieres capturar la data de ellos
  //Para formularios grandes, es bueno usar un widget de Form
  //El widget de form, cuando le haces submit, te da un objeto con toda la data de cada form item
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  final snackBar = SnackBar(
    content: Text('Credenciales inválidas'),
    duration: Duration(seconds: 3),
  );

  var isLoading = false;

  requestLogin() async {
    //Set state solo está disponible en los statefull widgets
    //Se usa para cambiar el valor de una variable que estas usando en el render
    //Es decir, que el valor de esa variable afecte lo que se le hace render
    //En este caso isloading se usa para mostrar un loading indicator si este valor es true
    //Puedes cambiar tu valor sin necesidad de setstate, pero no va a provocar un re-render.
    //SetState es una parte vital de flutter.
    setState(() {
      isLoading = true;
    });

    //El paquete http se usa para hacer requests, obvio, no?
    //puedes jugar con el response object, tiene toda la data que necesitas.
    var response = await http.post(
        'https://634b79d1d90b984a1e3a6809.mockapi.io/api/lyncargo/authenticate');

    //Aqui solo estoy mapeando el response.body a mi objeto Session
    //Puedes usar json.decode o json.encode para serializar y deserializar json
    Session session = new Session.fromJson(json.decode(response.body));
    //Luego paso mi objeto session al state manager, para que esté disponible en toda la app.
    Provider.of<Session>(context, listen: false).initSession(session);

    setState(() {
      isLoading = false;
    });
    //Navigator.push se usa para navegar a otra pantalla.
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
    //LAS PANTALLLAS deberian iniciar con el widget scaffold.
    //Pues es como una plantilla
    //Este tiene propiedades como body, navbar, bottombar, entre otras.
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors)),
        //Mediaquery lo puedes usar para saber el tipo de dispositivo que tienes
        //Puedes saber el tamano por ejemplo, para adecuar tu diseno a todo tipo de pantallas
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
              //Aqui solo digo que si isLoading es true, que ponga el progress indicator, de lo contrario, el boton
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
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
