import 'package:flutter/material.dart';
import 'package:lyncargo/models/shipments.dart';

//Este es cuando le das click a una list item, hace una navegacion a esta pantalla
class ShipDetail extends StatelessWidget {
  final Shipments shipment;
  //De esta forma pasamos parametros a otras pantallas
  //Existen otras formas.
  ShipDetail({key, this.shipment}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              '${shipment.hawbl == "" ? "BL no disponible" : shipment.hawbl}'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('${shipment.code}'),
              subtitle: const Text('Código'),
            ),
            ListTile(
              title: Text('${shipment.description}'),
              subtitle: const Text('Mercancía'),
            ),
            ListTile(
              title: Text('${shipment.status}'),
              subtitle: const Text('Estado'),
            ),
            ListTile(
              title: Text('${shipment.eta}'),
              subtitle: const Text('ETA'),
            ),
            ListTile(
              title: Text('${shipment.ets}'),
              subtitle: const Text('ETS'),
            ),
            ListTile(
              title: Text('${shipment.hawbl}'),
              subtitle: const Text('HBL'),
            ),
            ListTile(
              title: Text(
                  '${shipment.disembarked == null ? "(No disponible)" : shipment.disembarked}'),
              subtitle: const Text('Origen'),
            ),
            ListTile(
              title: Text(
                  '${shipment.embarked == null ? "(No disponible)" : shipment.embarked}'),
              subtitle: const Text('Destino'),
            ),
          ],
        ),
      );
}
