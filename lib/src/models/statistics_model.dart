class StatisticsModel {
  final String legend;
  final int conteo;

  StatisticsModel({required this.legend,required this.conteo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["legend"] = legend;
    data["conteo"] = conteo;
    return data;
  }

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      legend: json['legend'],
      conteo: json['conteo'],
    );
  }
}