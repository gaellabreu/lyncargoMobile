import 'package:flutter/foundation.dart';

class Session extends ChangeNotifier {
  String code = '';
  String email = '';
  String token = '';
  String name = '';
  String rnc = '';
  String phone = '';
  DateTime created = new DateTime.now();

  Session();

  initSession(Session session) {
    code = session.code;
    email = session.email;
    token = session.token;
    name = session.name;
    rnc = session.rnc;
    phone = session.phone;
    notifyListeners();
  }

  Session.fromJson(Map<String, dynamic> json)
      : code = json['codigo'],
        email = json['nombre'],
        token = json['jwt'],
        name = json['nombre'],
        rnc = json['rnc'],
        phone = json['tel1'];
}
