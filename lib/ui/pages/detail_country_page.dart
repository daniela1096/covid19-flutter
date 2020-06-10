import 'dart:convert';

import 'package:covid19/models/country.dart';
import 'package:covid19/models/summary_response.dart';
import 'package:covid19/ui/widgets/info_general_widget.dart';
import 'package:covid19/ui/widgets/info_specific_api_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailCountryPage extends StatefulWidget {
  final Country country;
  const DetailCountryPage({Key key, this.country}) : super(key: key);

  @override
  _DetailCountryPageState createState() => _DetailCountryPageState();
}

class _DetailCountryPageState extends State<DetailCountryPage> {
  Future<SummaryResponse> summaryResponse;

  @override
  void initState() {
    super.initState();
    summaryResponse = getSummaryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(widget.country.country.toString()),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: CardInfoGeneralWidgets(
                title: "Covid-19 en " + widget.country.country.toString(),
                avatar: widget.country.countryCode,
                info: FutureBuilder<SummaryResponse>(
                  future: summaryResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: InfoWidgets(
                              title: 'Confirmados totales',
                              data: widget.country.totalConfirmed.toString(),
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: InfoWidgets(
                              title: 'Bajas totales',
                              data: widget.country.totalDeaths.toString(),
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            child: InfoWidgets(
                              title: 'Recuperados totales',
                              data: widget.country.totalRecovered.toString(),
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
}
