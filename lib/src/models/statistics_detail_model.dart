class StatisticDetailsModel {
  final String carnet;
  final String first_name;
  final String last_name;
  final String? date;

  StatisticDetailsModel({required this.carnet,required this.first_name, required this.last_name, this.date});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["carnet"] = carnet;
    data["first_name"] = first_name;
    data["last_name"] = last_name;
    data["date"] = date;
    return data;
  }

  factory StatisticDetailsModel.fromJson(Map<String, dynamic> json) {
    return StatisticDetailsModel(
      carnet: json['carnet'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      date: json['date'],
    );
  }
}