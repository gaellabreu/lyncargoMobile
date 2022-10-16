import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyncargo/models/shipments.dart';
import 'package:lyncargo/ship/ship_detail.dart';

//Este es el widget para el Card o List Item que se renderiza en la lista de embarques
//Stateless widget no hace re-render en ningun momento, pues no tiene estado
//Es un widget estatico
class ShipListItem extends StatelessWidget {
  final Shipments shipment;
  //De esta forma pasamos parametros a otras pantallas
  //Existen otras formas.
  ShipListItem({key, this.shipment}) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => ShipDetail(
                  shipment: shipment,
                ))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 60, bottom: 10),
                            child: Text(
                              shipment.hawbl != ''
                                  ? '${shipment.hawbl}'
                                  : 'BL NO DISPONIBLE',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              '${shipment.description.toUpperCase()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(children: [
                                    Text('ETS: ${shipment.ets}'),
                                    Text(
                                      shipment.embarked != null
                                          ? '${shipment.embarked}'
                                          : 'DESCONOCIDO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                  Icon(Icons.arrow_forward_ios),
                                  Column(children: [
                                    Text('ETA: ${shipment.eta}'),
                                    Text(
                                        shipment.disembarked != null
                                            ? '${shipment.disembarked}'
                                            : 'DESCONOCIDO',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ])
                                ]),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    shipment.status != null ? shipment.status : ' - ',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                  shadowColor: Colors.indigo,
                  elevation: 3,
                ),
              ],
            ),
          ),
        ),
      );
}
