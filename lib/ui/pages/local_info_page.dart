import 'dart:convert';

import 'package:covid19/models/country.dart';
import 'package:covid19/models/summary_response.dart';
import 'package:covid19/ui/widgets/info_specific_api_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid19/ui/widgets/info_general_widget.dart';

class LocalInfoPage extends StatefulWidget {
  @override
  _LocalInfoPageState createState() => _LocalInfoPageState();
}

class _LocalInfoPageState extends State<LocalInfoPage> {
  Future<SummaryResponse> summaryResponse;
  var description =
      'Los coronavirus (CoV) son virus que surgen periódicamente en diferentes áreas del mundo y que causan Infección Respiratoria Aguda (IRA), es decir gripa, que pueden llegar a ser leve, moderada o grave.';

  @override
  void initState() {
    super.initState();
    summaryResponse = getSummaryData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/logo_sofka.png'),
                ),
                RichText(
                  text: TextSpan(
                    text: '#',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 30.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'MeQuedoEnCasa',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: CardInfoGeneralWidgets(
                  title: "Covid-19 en Colombia",
                  avatar: 'CO',
                  info: FutureBuilder<SummaryResponse>(
                      future: summaryResponse,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: InfoWidgets(
                                  title: 'Confirmados totales',
                                  data: getColombiaData(snapshot.data.countries)
                                      .totalConfirmed
                                      .toString(),
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: InfoWidgets(
                                  title: 'Bajas totales',
                                  data: getColombiaData(snapshot.data.countries)
                                      .totalDeaths
                                      .toString(),
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: InfoWidgets(
                                  title: 'Recuperados totales',
                                  data: getColombiaData(snapshot.data.countries)
                                      .totalRecovered
                                      .toString(),
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('error');
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8.0),
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '¿Qué es el covid 19?',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0)
                                .copyWith(left: 16.0),
                            child: Text(
                              description,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/virus.png',
                            width: 80.0,
                            height: 80.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Text(
                        'Más información',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {}),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            child: Column(
              children: <Widget>[
                Text(
                  'Sintomas',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: _ItemCard(
                            title: 'Tos seca',
                            image: 'assets/cough.png',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: _ItemCard(
                            title: 'Secreción nasal',
                            image: 'assets/nose.png',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<SummaryResponse> getSummaryData() async {
    final response = await http.get('https://api.covid19api.com/summary');
    if (response.statusCode == 200) {
      var summaryResponse =
          SummaryResponse.fromJson(json.decode(response.body));
      print('respuesta:');
      print(summaryResponse?.global?.totalDeaths ?? 0);
      return summaryResponse;
    } else {
      throw Exception('Fallo al cargar la data');
    }
  }

  Country getColombiaData(List<Country> countries) {
    return countries.firstWhere((country) => country.slug == 'colombia');
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  final String image;

  _ItemCard({
    this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            height: 100.0,
            width: 100.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
