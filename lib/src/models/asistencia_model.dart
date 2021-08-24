class Asistencia {
  final int id;
  final String first_name;
  final String last_name;
  final String carnet;
  final String course_code;
  final String course_name;
  final String section;
  final String start_time;
  final String end_time;
  final String? date;

  Asistencia({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.carnet,
    required this.course_code,
    required this.course_name,
    required this.section,
    required this.start_time,
    required this.end_time,
    this.date
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        carnet: json['carnet'],
        course_code: json['course_code'],
        course_name: json['course_name'],
        section: json['section'],
        start_time: json['start_time'],
        end_time: json['end_time'],
        date: json['date']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': first_name,
    'last_name':last_name,
    'carnet': carnet,
    'course_code':course_code,
    'course_name':course_name,
    'section':section,
    'start_time':start_time,
    'end_time':end_time,
    'date':date
  };
}