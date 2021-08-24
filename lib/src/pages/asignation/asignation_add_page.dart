import 'package:control_asistencia/src/pages/asignation/asignation_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/providers/current_user.dart';

class AsignationAddPage extends StatefulWidget {
  @override
  _AsignationAddPageState createState() => _AsignationAddPageState();
}

class _AsignationAddPageState extends State<AsignationAddPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController section = new TextEditingController();
  TextEditingController username_student = new TextEditingController();

  Future _createAsignation() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.post(Uri.parse("${URL_BASE.Env.url_base}asignation/"),
        body: {
          "section": section.text,
          "username_student": username_student.text,
        },
        headers: {
          "Authorization": accessToken
        }
    );
  }

  void _onConfirm(context) async {
    await _createAsignation();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Agregar Asignacion"),
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
        child: AsignationForm(
          formKey: formKey,
          section: section,
          username_student: username_student,
          newRow: true,
        ),
      ),
    );
  }
}
