class Professor {
  final int id;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final Map<String, dynamic> rol;

  Professor({
    required this.id,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.rol
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        rol: json['rol']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'first_name': first_name,
    'last_name': last_name,
    'rol': rol
  };
}