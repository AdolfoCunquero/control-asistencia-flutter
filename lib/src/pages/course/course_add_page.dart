import 'package:control_asistencia/src/pages/course/course_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class CourseAddPage extends StatefulWidget {
  @override
  _CourseAddPageState createState() => _CourseAddPageState();
}

class _CourseAddPageState extends State<CourseAddPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController course_code = new TextEditingController();
  TextEditingController course_name = new TextEditingController();

  Future _createCourse() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.post(Uri.parse("${URL_BASE.Env.url_base}course/"),
      body: {
        "course_code": course_code.text,
        "course_name": course_name.text,
      },
      headers: {
        "Authorization": accessToken
      }
    );
  }

  void _onConfirm(context) async {
    await _createCourse();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Agregar curso"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Guardar"),
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
          newRow: true,
        ),
      ),
    );
  }
}

