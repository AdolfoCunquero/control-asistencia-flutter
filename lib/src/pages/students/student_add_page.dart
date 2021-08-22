import 'package:control_asistencia/src/pages/students/student_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class StudentAddPage extends StatefulWidget {

  @override
  _StudentAddPageState createState() => _StudentAddPageState();
}

class _StudentAddPageState extends State<StudentAddPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController carnet = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController first_name = new TextEditingController();
  TextEditingController last_name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future _createStudent() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.post(Uri.parse("${URL_BASE.Env.url_base}auth/register/"),
      body: {
        "carnet": carnet.text,
        "username": username.text,
        "email": email.text,
        "first_name": first_name.text,
        "last_name": last_name.text,
        "password": password.text,
        "rol":"3"
      },
      headers: {
        "Authorization": accessToken
      }
    );
  }

  void _onConfirm(context) async {
    await _createStudent();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Agregar estudiante"),
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
        child: StudentForm(
          formKey: formKey,
          carnet: carnet,
          username: username,
          email: email,
          first_name: first_name,
          last_name: last_name,
          newRow: true,
          password: password,
        ),
      ),
    );
  }
}
