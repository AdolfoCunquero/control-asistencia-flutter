import 'package:control_asistencia/src/models/professor_model.dart';
import 'package:control_asistencia/src/pages/professor/professor_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class ProfessorEditPage extends StatefulWidget {

  final Professor professor;

  ProfessorEditPage({required this.professor});

  @override
  _ProfessorEditPageState createState() => _ProfessorEditPageState();
}

class _ProfessorEditPageState extends State<ProfessorEditPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController first_name = new TextEditingController();
  TextEditingController last_name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future editProfessor() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.put(Uri.parse("${URL_BASE.Env.url_base}auth/update/${widget.professor.id}/"),
        body: {
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
    await editProfessor();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    username = TextEditingController(text: widget.professor.username);
    email = TextEditingController(text: widget.professor.email);
    first_name = TextEditingController(text: widget.professor.first_name);
    last_name = TextEditingController(text: widget.professor.last_name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Editar catedratico")
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
        child: ProfessorForm(
          formKey: formKey,
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
