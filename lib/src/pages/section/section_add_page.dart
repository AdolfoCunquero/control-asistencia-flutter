import 'package:control_asistencia/src/pages/section/section_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/providers/current_user.dart';

class SectionAddPage extends StatefulWidget {
  @override
  _SectionAddPageState createState() => _SectionAddPageState();
}

class _SectionAddPageState extends State<SectionAddPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController section = new TextEditingController();
  TextEditingController year = new TextEditingController();
  TextEditingController course_code = new TextEditingController();
  TextEditingController start_time = new TextEditingController();
  TextEditingController end_time = new TextEditingController();
  TextEditingController username_professor = new TextEditingController();
  TextEditingController semester = new TextEditingController();

  Future _createSection() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.post(Uri.parse("${URL_BASE.Env.url_base}section/"),
        body: {
          "section": section.text,
          "year": year.text,
          "course_code": course_code.text,
          "username_professor": username_professor.text,
          "start_time": start_time.text,
          "end_time": end_time.text,
          "semester": semester.text
        },
        headers: {
          "Authorization": accessToken
        }
    );
  }

  void _onConfirm(context) async {
    await _createSection();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Agregar seccion"),
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
        child: SectionForm(
          formKey: formKey,
          section: section,
          year: year,
          course_code: course_code,
          username_professor: username_professor,
          start_time: start_time,
          end_time: end_time,
          semester: semester,
          newRow: true,
        ),
      ),
    );
  }


}
