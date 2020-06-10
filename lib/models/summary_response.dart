import 'package:covid19/models/country.dart';
import 'package:covid19/models/global.dart';

class SummaryResponse {
  List<Country> countries;
  String date;
  Global global;

  SummaryResponse({this.countries, this.date, this.global});

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      countries: json['Countries'] != null
          ? (json['Countries'] as List).map((i) => Country.fromJson(i)).toList()
          : null,
      date: json['Date'],
      global: json['Global'] != null ? Global.fromJson(json['Global']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    if (this.countries != null) {
      data['Countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    if (this.global != null) {
      data['Global'] = this.global.toJson();
    }
    return data;
  }
}
