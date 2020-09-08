import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
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

  getShipments() async {
    var response = await http.get(
        'https://lyncargocloud.ddns.net/bprestservices/ExpedientesCourier.rsvc',
        headers: {
          'X-Api-Key': 'CALi10rrcxbjC8DklVO93NMhZwxekwx5zb234ff4f53fdf33yil',
          'X-Bpdominio-Id': 'lce',
          'Authorization':
              'Bearer ${Provider.of<Session>(context, listen: true).token}'
        });

    setState(() {
      shipments.addAll((json.decode(response.body) as List)
          .map((i) => Shipments.fromJson(i))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail_outline),
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                builder: (BuildContext context) => QuoteMail())),
          )
        ], title: Text('${Provider.of<Session>(context, listen: true).name}')),
        body: ListView.builder(
            itemCount: shipments.length,
            itemBuilder: (BuildContext context, int i) =>
                ShipListItem(shipment: shipments[i])),
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
                element.hawbl.toLowerCase().contains(query.toLowerCase()))))
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
