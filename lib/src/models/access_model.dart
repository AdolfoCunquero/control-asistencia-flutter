class AccessModel {
  final String access;
  final String refresh;

  AccessModel({required this.access,required this.refresh});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["access"] = access;
    data["refresh"] = refresh;
    return data;
  }

  factory AccessModel.fromJson(Map<String, dynamic> json) {
    return AccessModel(
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}