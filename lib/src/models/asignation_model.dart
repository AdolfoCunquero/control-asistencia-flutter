class Asignation {
  final int id;
  final Map<String, dynamic> section;
  final Map<String, dynamic> username_student;

  Asignation({
    required this.id,
    required this.section,
    required this.username_student
  });

  factory Asignation.fromJson(Map<String, dynamic> json) {
    return Asignation(
        id: json['id'],
        section: json['section'],
        username_student: json['username_student']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'seciton': section,
    'username_student': username_student
  };
}