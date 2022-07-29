import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class QuoteMail extends StatefulWidget {
  final String name;
  QuoteMail({Key key, @required this.name}) : super(key: key);

  @override
  _QuoteMailState createState() => _QuoteMailState();
}

class _QuoteMailState extends State<QuoteMail> {
  String dropdownValue = 'Contenedor full';
  final outController = new TextEditingController();
  final inController = new TextEditingController();
  final merchandiseController = new TextEditingController();
  final commentController = new TextEditingController();

  void _sendQuotation() async {
    final Email email = Email(
      body: '''
      <p>Solicitamos una cotización con los siguientes detalles</p>
      <p>
        <b>Salida: </b> ${outController.text}
      </p>
      <p>
        <b>Llegada: </b> ${inController.text}
      </p>
      <p>
        <b>Mercancía: </b> ${merchandiseController.text}
      </p>
      <p>
        <b>Tipo: </b> $dropdownValue
      </p>
      <p>
        <b>Observación: </b>
        ${commentController.text}
      </p>
      ''',
      subject: 'COTIZACIÓN DE FLETE - ${widget.name}',
      recipients: ['info@lyncargo.net'],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cotización'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: outController,
                  decoration: InputDecoration(hintText: 'Lugar de salida'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: inController,
                  decoration: InputDecoration(hintText: 'Lugar de llegada'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: merchandiseController,
                  decoration: InputDecoration(hintText: 'Mercancía'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 4, top: 4),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                      ),
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        'Contenedor full',
                        'Consolidado',
                        'Aereo',
                        'Otros'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  maxLines: 10,
                  controller: commentController,
                  decoration: InputDecoration(hintText: 'Comentario'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => this._sendQuotation(),
          child: Icon(Icons.send),
        ),
      );
}
