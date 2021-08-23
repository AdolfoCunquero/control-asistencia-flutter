class Section {
  final int id;
  final String section;
  final int year;
  final Map<String, dynamic> course_code;
  final String start_time;
  final String end_time;
  final Map<String, dynamic> username_professor;
  final int semester;

  Section({
    required this.id,
    required this.section,
    required this.year,
    required this.course_code,
    required this.start_time,
    required this.end_time,
    required this.username_professor,
    required this.semester
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
        id: json['id'],
        section: json['section'],
        year: json['year'],
        course_code: json['course_code'],
        start_time: json['start_time'],
        end_time: json['end_time'],
        username_professor: json['username_professor'],
        semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'section': section,
    'year': year,
    'course_code': course_code,
    'start_time': start_time,
    'end_time': end_time,
    'username_professor': username_professor,
    'semester': semester,
  };
}