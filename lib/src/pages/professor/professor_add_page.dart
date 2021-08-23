import 'package:control_asistencia/src/pages/professor/professor_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class ProfessorAddPage extends StatefulWidget {
  @override
  _ProfessorAddPageState createState() => _ProfessorAddPageState();
}

class _ProfessorAddPageState extends State<ProfessorAddPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController first_name = new TextEditingController();
  TextEditingController last_name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future _createProfessor() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.post(Uri.parse("${URL_BASE.Env.url_base}auth/register/"),
        body: {
          "username": username.text,
          "email": email.text,
          "first_name": first_name.text,
          "last_name": last_name.text,
          "password": password.text,
          "rol":"2"
        },
        headers: {
          "Authorization": accessToken
        }
    );
  }

  void _onConfirm(context) async {
    await _createProfessor();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Agregar catedratico"),
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
        child: ProfessorForm(
          formKey: formKey,
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
