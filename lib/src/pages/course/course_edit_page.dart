import 'package:control_asistencia/src/models/course_model.dart';
import 'package:control_asistencia/src/pages/course/course_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class CourseEditPage extends StatefulWidget {
  final Course course;

  CourseEditPage({required this.course});

  @override
  _CourseEditPageState createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController course_code = new TextEditingController();
  TextEditingController course_name = new TextEditingController();

  Future editCourse() async {

    return await http.put(Uri.parse("${URL_BASE.Env.url_base}course/${widget.course.course_code}/"),
      body: {
        "course_code": course_code.text,
        "course_name": course_name.text
      },
    );
  }

  void _onConfirm(context) async {
    await editCourse();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    course_code = TextEditingController(text: widget.course.course_code);
    course_name = TextEditingController(text: widget.course.course_name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Editar curso")
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text('Guardar cambios'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _onConfirm(context);
            }
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: CourseForm(
          formKey: formKey,
          course_code: course_code,
          course_name: course_name,
          newRow: false,
        ),
      ),
    );
  }
}
