import 'package:intl/intl.dart';

final f = new DateFormat('dd/MM/yyyy');

class Shipments {
  String code;
  String description;
  String status;
  String eta;
  String ets;
  String hawbl;
  String disembarked;
  String embarked;

  Shipments.fromJson(Map<String, dynamic> json)
      : code = json['codigo'],
        description = json['descripcion_carga'],
        status = json['estatus'],
        eta = f.format(new DateTime.fromMillisecondsSinceEpoch(json['eta'])),
        ets = f.format(new DateTime.fromMillisecondsSinceEpoch(json['ets'])),
        hawbl = json['h_aw_bl'],
        disembarked = json['desembarque'],
        embarked = json['embarque'];
}
