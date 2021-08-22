class Student {
  final int id;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String carnet;
  final Map<String, dynamic> rol;

  Student({
    required this.id,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.carnet,
    required this.rol
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        carnet: json['carnet'],
        rol: json['rol']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'first_name': first_name,
    'last_name': last_name,
    'carnet': carnet,
    'rol': rol
  };
}