import 'dart:convert';

import 'package:covid19/models/country.dart';
import 'package:covid19/models/global.dart';
import 'package:covid19/models/summary_response.dart';
import 'package:covid19/ui/pages/detail_country_page.dart';
import 'package:covid19/ui/widgets/info_general_widget.dart';
import 'package:covid19/ui/widgets/info_specific_api_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class GlobalPage extends StatefulWidget {
  @override
  _GlobalPageState createState() => _GlobalPageState();
}

class _GlobalPageState extends State<GlobalPage> {
  Future<SummaryResponse> summaryFuture;
  Future<List<Country>> countriesList;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    summaryFuture = getSummaryData();
    countriesList = summaryFuture.then((value) => value.countries);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: CardInfoGeneralWidgets(
                    title: "Datos globales",
                    avatar: 'assets/world.png',
                    info: FutureBuilder<SummaryResponse>(
                      future: summaryFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: InfoWidgets(
                                  title: 'Confirmados totales',
                                  data: getGlobalData(snapshot.data)
                                          ?.totalConfirmed
                                          ?.toString() ??
                                      '',
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: InfoWidgets(
                                  title: 'Bajas totales',
                                  data: getGlobalData(snapshot.data)
                                          ?.totalDeaths
                                          ?.toString() ??
                                      '',
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: InfoWidgets(
                                  title: 'Recuperados totales',
                                  data: getGlobalData(snapshot.data)
                                          ?.totalRecovered
                                          ?.toString() ??
                                      '',
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
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Listado de paises con Covid 19',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              countriesList = countriesList.then((value) =>
                                  Future.value(value.reversed.toList()));
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.sort_by_alpha,
                                color: Colors.white,
                              ),
                              Text(
                                'Ordenar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder<List<Country>>(
              future: countriesList,
              initialData: [],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildListDelegate(snapshot.data
                        .map(
                          (e) => _CountryItem(
                            country: e,
                          ),
                        )
                        .toList()),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          summaryFuture = getSummaryData();
                          countriesList =
                              summaryFuture.then((value) => value.countries);
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          Text(
                            'Reintentar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<SummaryResponse> getSummaryData() async {
    final response = await http.get('https://api.covid19api.com/summary');
    if (response.statusCode == 200) {
      return SummaryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Global getGlobalData(SummaryResponse summary) {
    return summary.global;
  }

  void _onRefresh() async {
    summaryFuture = getSummaryData();
    countriesList = summaryFuture.then((value) => value.countries);
    await summaryFuture.then((value) => _refreshController.refreshCompleted());
  }
}

class _CountryItem extends StatelessWidget {
  final Country country;

  _CountryItem({this.country});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCountryPage(
              country: country,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    country?.country ?? '',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              _CountryIconsItems(
                icon: Icons.check_circle,
                data: country?.totalConfirmed?.toString() ?? '',
                color: Colors.red,
              ),
              _CountryIconsItems(
                icon: Icons.sentiment_very_dissatisfied,
                data: country?.totalDeaths?.toString() ?? '',
                color: Colors.black,
              ),
              _CountryIconsItems(
                icon: Icons.favorite_border,
                data: country?.totalRecovered?.toString() ?? '',
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryIconsItems extends StatelessWidget {
  final String data;
  final IconData icon;
  final Color color;

  _CountryIconsItems({
    this.data,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              icon,
              color: color,
              size: 15.0,
            ),
          ),
          Text(
            data,
            style: TextStyle(
              color: color,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
