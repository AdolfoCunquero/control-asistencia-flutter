import 'package:flutter/material.dart';
import 'package:control_asistencia/src/models/section_model.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/pages/section/section_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';

class SectionEditPage extends StatefulWidget {
  final Section section;

  SectionEditPage({required this.section});
  @override
  _SectionEditPageState createState() => _SectionEditPageState();
}

class _SectionEditPageState extends State<SectionEditPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController section = new TextEditingController();
  TextEditingController year = new TextEditingController();
  TextEditingController course_code = new TextEditingController();
  TextEditingController username_professor = new TextEditingController();
  TextEditingController start_time = new TextEditingController();
  TextEditingController end_time = new TextEditingController();
  TextEditingController semester = new TextEditingController();

  Future editSection() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.put(Uri.parse("${URL_BASE.Env.url_base}section/${widget.section.id}/"),
        body: {
          "section":section.text,
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
    await editSection();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    section = TextEditingController(text: widget.section.section);
    year = TextEditingController(text: widget.section.year.toString());
    course_code = TextEditingController(text: widget.section.course_code["course_code"]);
    start_time = TextEditingController(text: widget.section.start_time);
    end_time = TextEditingController(text: widget.section.end_time);
    semester = TextEditingController(text: widget.section.semester.toString());
    String idProffesor = widget.section.username_professor["id"].toString();
    username_professor = TextEditingController(text: idProffesor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Editar seccion")
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text('Guardar cambios'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _onConfirm(context);
            } else{
              print("no valido");
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
          username_professor:  username_professor,
          start_time: start_time,
          end_time: end_time,
          semester: semester,
          newRow: false,
        ),
      ),
    );
  }
}

