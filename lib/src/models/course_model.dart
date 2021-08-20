class Course {
  final String course_code;
  final String course_name;

  Course({
    required this.course_code,
    required this.course_name,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      course_code: json['course_code'],
      course_name: json['course_name']
    );
  }

  Map<String, dynamic> toJson() => {
    'course_code': course_code,
    'course_name': course_name,
  };
}