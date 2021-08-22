import 'package:control_asistencia/src/models/student_model.dart';
import 'package:control_asistencia/src/pages/students/student_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class StudentEditPage extends StatefulWidget {

  final Student student;

  StudentEditPage({required this.student});

  @override
  _StudentEditPageState createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController carnet = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController first_name = new TextEditingController();
  TextEditingController last_name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future editStudent() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.put(Uri.parse("${URL_BASE.Env.url_base}auth/update/${widget.student.id}/"),
        body: {
          "carnet":carnet.text,
          "email": email.text,
          "username": username.text,
          "first_name": first_name.text,
          "last_name": last_name.text
        },
        headers: {
          "Authorization": accessToken
        }
    );
  }

  void _onConfirm(context) async {
    await editStudent();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    carnet = TextEditingController(text: widget.student.carnet);
    username = TextEditingController(text: widget.student.username);
    email = TextEditingController(text: widget.student.email);
    first_name = TextEditingController(text: widget.student.first_name);
    last_name = TextEditingController(text: widget.student.last_name);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Editar estudiante")
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
        child: StudentForm(
          formKey: formKey,
          carnet: carnet,
          email: email,
          username: username,
          first_name:  first_name,
          last_name: last_name,
          newRow: false,
        ),
      ),
    );
  }
}
