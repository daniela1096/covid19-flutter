class Country {
  String country;
  String countryCode;
  String date;
  int newConfirmed;
  int newDeaths;
  int newRecovered;
  String slug;
  int totalConfirmed;
  int totalDeaths;
  int totalRecovered;

  Country(
      {this.country,
      this.countryCode,
      this.date,
      this.newConfirmed,
      this.newDeaths,
      this.newRecovered,
      this.slug,
      this.totalConfirmed,
      this.totalDeaths,
      this.totalRecovered});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      country: json['Country'],
      countryCode: json['CountryCode'],
      date: json['Date'],
      newConfirmed: json['NewConfirmed'],
      newDeaths: json['NewDeaths'],
      newRecovered: json['NewRecovered'],
      slug: json['Slug'],
      totalConfirmed: json['TotalConfirmed'],
      totalDeaths: json['TotalDeaths'],
      totalRecovered: json['TotalRecovered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country'] = this.country;
    data['CountryCode'] = this.countryCode;
    data['Date'] = this.date;
    data['NewConfirmed'] = this.newConfirmed;
    data['NewDeaths'] = this.newDeaths;
    data['NewRecovered'] = this.newRecovered;
    data['Slug'] = this.slug;
    data['TotalConfirmed'] = this.totalConfirmed;
    data['TotalDeaths'] = this.totalDeaths;
    data['TotalRecovered'] = this.totalRecovered;
    return data;
  }
}
