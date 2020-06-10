class Global {
  int newConfirmed;
  int newDeaths;
  int newRecovered;
  int totalConfirmed;
  int totalDeaths;
  int totalRecovered;

  Global(
      {this.newConfirmed,
      this.newDeaths,
      this.newRecovered,
      this.totalConfirmed,
      this.totalDeaths,
      this.totalRecovered});

  factory Global.fromJson(Map<String, dynamic> json) {
    return Global(
      newConfirmed: json['NewConfirmed'],
      newDeaths: json['NewDeaths'],
      newRecovered: json['NewRecovered'],
      totalConfirmed: json['TotalConfirmed'],
      totalDeaths: json['TotalDeaths'],
      totalRecovered: json['TotalRecovered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NewConfirmed'] = this.newConfirmed;
    data['NewDeaths'] = this.newDeaths;
    data['NewRecovered'] = this.newRecovered;
    data['TotalConfirmed'] = this.totalConfirmed;
    data['TotalDeaths'] = this.totalDeaths;
    data['TotalRecovered'] = this.totalRecovered;
    return data;
  }
}
