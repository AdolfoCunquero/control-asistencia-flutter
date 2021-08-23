class UserModel {
  final String username;
  final String first_name;
  final String last_name;
  final int rol;

  UserModel({
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.rol
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["username"] = username;
    data["first_name"] = first_name;
    data["last_name"] = last_name;
    data["rol"] = rol;
    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      rol: json['rol'],
    );
  }
}