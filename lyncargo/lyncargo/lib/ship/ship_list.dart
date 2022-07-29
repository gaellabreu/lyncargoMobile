import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lyncargo/models/Session.dart';
import 'package:lyncargo/models/shipments.dart';
import 'package:lyncargo/ship/quote_mail.dart';
import 'package:lyncargo/ship/ship_list_item.dart';
import 'package:provider/provider.dart';

class ShipList extends StatefulWidget {
  @override
  _ShipListState createState() => _ShipListState();
}

class _ShipListState extends State<ShipList> {
  @override
  void initState() {
    super.initState();

    //DESDE AQUI PONES LO QUE QUIERAS HACER
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getShipments();
  }

  final List<Shipments> shipments = [];
  final status = ["LIBERADO", "CANCELADO", "MANIFESTADO", "AVISADO", null];

  getShipments() async {
    var tokenDate = Provider.of<Session>(context, listen: false).created;

    if (new DateTime.now().difference(tokenDate).inMinutes > 29) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sesión expirada'),
        duration: Duration(seconds: 3),
      ));
      Navigator.pop(context);
    }

    var response = await http.get(
        'https://lyncargo.westcentralus.cloudapp.azure.com/bprestservices/ExpedientesCourier.rsvc',
        headers: {
          'X-Api-Key': 'CALi10rrcxbjC8DklVO93NMhZwxekwx5zb234ff4f53fdf33yil',
          'X-Bpdominio-Id': 'lce',
          'Authorization':
              'Bearer ${Provider.of<Session>(context, listen: false).token}'
        });

    setState(() {
      var list = (json.decode(response.body) as List)
          .map((i) => Shipments.fromJson(i))
          .toList();

      list.sort((a, b) {
        var dia1 = int.parse(a.eta.split('/')[0]);
        var mes1 = int.parse(a.eta.split('/')[1]);
        var ano1 = int.parse(a.eta.split('/')[2]);

        var dia2 = int.parse(b.eta.split('/')[0]);
        var mes2 = int.parse(b.eta.split('/')[1]);
        var ano2 = int.parse(b.eta.split('/')[2]);

        return DateTime(ano2, mes2, dia2).millisecondsSinceEpoch -
            DateTime(ano1, mes1, dia1).millisecondsSinceEpoch;
      });

      shipments.clear();
      shipments.addAll(list);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${shipments.length} Embarques encontrados'),
        duration: Duration(seconds: 3),
      ));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: new IconButton(
                icon: Icon(Icons.refresh), onPressed: () => getShipments()),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.mail_outline),
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => QuoteMail(
                          name:
                              Provider.of<Session>(context, listen: true).name,
                        ))),
              )
            ],
            title: Text('${Provider.of<Session>(context, listen: true).name}')),
        body: RefreshIndicator(
          onRefresh: () => getShipments(),
          child: ListView.builder(
              itemCount: shipments.length,
              itemBuilder: (BuildContext context, int i) =>
                  ShipListItem(shipment: shipments[i])),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context,
                delegate: ShipmentSearch(shipments: shipments))),
      );
}

class ShipmentSearch extends SearchDelegate<Shipments> {
  final List<Shipments> shipments;

  ShipmentSearch({this.shipments});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var filter = shipments
        .where((element) => (element.disembarked != null &&
                element.disembarked
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
            (element.description != null &&
                element.description
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
            (element.embarked != null &&
                element.embarked.toLowerCase().contains(query.toLowerCase())) ||
            (element.ets != null &&
                element.ets.toLowerCase().contains(query.toLowerCase())) ||
            (element.eta != null &&
                element.eta.toLowerCase().contains(query.toLowerCase())) ||
            (element.hawbl != null &&
                element.hawbl.toLowerCase().contains(query.toLowerCase())) ||
            (element.status != null &&
                element.status.toLowerCase().contains(query.toLowerCase()))))
        .toList();
    return filter.length == 0
        ? Center(child: Text('Sin resultados'))
        : ListView.builder(
            itemCount: filter.length,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShipListItem(shipment: filter[index]),
                ));
  }
}
