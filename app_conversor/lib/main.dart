import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var request = Uri.parse("https://api.hgbrasil.com/finance?key=d18b57f7");

void main() {
  runApp(MaterialApp(home: Conversor()));
}

class Conversor extends StatefulWidget {
  const Conversor({Key? key}) : super(key: key);

  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double dolar;
  late double euro;

  void _realChanged(String text) {
    if(text != "") {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    }
  }

  void _dolarChanged(String text) {
    if(text != "") {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text) {
    if(text != ""){ 
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando os dados...",
                    style: TextStyle(color: Colors.pink, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar os dados :(",
                      style: TextStyle(color: Colors.pink, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: _realChanged,
                          controller: realController,
                          decoration: const InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$"),
                          style: TextStyle(color: Colors.pink, fontSize: 25),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          onChanged: _dolarChanged,
                          controller: dolarController,
                          decoration: const InputDecoration(
                              labelText: "Dólares",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "US\$"),
                          style: TextStyle(color: Colors.pink, fontSize: 25),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          onChanged: _euroChanged,
                          controller: euroController,
                          decoration: const InputDecoration(
                              labelText: "Euros",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "£\$"),
                          style: TextStyle(color: Colors.pink, fontSize: 25),
                        )
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }

  //função abaixo para buscar os dados da api
  Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }
}
