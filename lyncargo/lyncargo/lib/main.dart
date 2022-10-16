import 'package:flutter/material.dart';
import 'package:lyncargo/login/login.dart';
import 'package:lyncargo/models/Session.dart';
import 'package:provider/provider.dart';

//Este es basicamente el punto de inicio de la app.
void main() {
  //ChangeNotifierProvider se usa como un state management global del app.
  //Tengo variables de las cuales puedo leer y escribir desde cualquier parte de la app.
  //A su vez, puedo reaccionar a esos cambios.
  //En este caso, solo tengo un objecto llamado Session, para el estado del usuario que hizo log in.
  runApp(ChangeNotifierProvider(
      create: (context) => Session(), builder: (context, child) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //El widget MaterialApp un tipo de base para una app basada en Android o Material Design.
    //En caso de querer orientarlo a Apple, puedes usar CuppertinApp
    //Los parametros de ambos son distintos
    //De todas formas puedes intercambiar widgets de Apple a Android y al revez
    return MaterialApp(
        title: 'LynCargo',
        //Aqui puedes modificar el estilo de toda tu aplicacion
        //El objeto ThemeData acepta una cantidad enorme de parametros
        //Puedes modificar los colores, formas, etc de cada tipo de widget.
        //En este caso es una modificacion simple a los colores principales, bordes, entre otros.
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
