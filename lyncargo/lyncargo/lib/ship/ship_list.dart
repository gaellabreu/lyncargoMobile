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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getShipments();
  }

  final List<Shipments> shipments = [];
  final status = ["LIBERADO", "CANCELADO", "MANIFESTADO", "AVISADO", null];

  getShipments() async {
    var response = await http.get(
        'https://634b79d1d90b984a1e3a6809.mockapi.io/api/lyncargo/shipments');

    setState(() {
      var list = (json.decode(response.body) as List)
          .map((i) => Shipments.fromJson(i))
          .toList();

      shipments.clear();
      shipments.addAll(list);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${shipments.length} Embarques encontrados'),
        duration: Duration(seconds: 3),
      ));
    });
  }

//Este es el build del widget de la lista
//Ojo, de la lista, no de item individual, ese es otro widget.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail_outline),
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                builder: (BuildContext context) => QuoteMail(
                      name: Provider.of<Session>(context, listen: true).name,
                    ))),
          )
        ], title: Text('${Provider.of<Session>(context, listen: true).name}')),
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

//Todo esto aqui debajo es para que funcione el search en toda la lista.
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
