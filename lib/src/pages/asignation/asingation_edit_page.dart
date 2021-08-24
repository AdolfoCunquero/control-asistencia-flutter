import 'package:control_asistencia/src/models/asignation_model.dart';
import 'package:control_asistencia/src/pages/asignation/asignation_form.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:flutter/material.dart';

class AsignationEditPage extends StatefulWidget {

  final Asignation asignation;

  AsignationEditPage({required this.asignation});
  @override
  _AsignationEditPageState createState() => _AsignationEditPageState();
}

class _AsignationEditPageState extends State<AsignationEditPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController section = new TextEditingController();
  TextEditingController username_student = new TextEditingController();

  Future editAsignation() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    return await http.put(Uri.parse("${URL_BASE.Env.url_base}asignation/${widget.asignation.id}/"),
        body: {
          "section":section.text,
          "username_student": username_student.text,
        },
        headers: {
          "Authorization": accessToken
        }
    );
  }

  void _onConfirm(context) async {
    await editAsignation();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {

    section = TextEditingController(text: widget.asignation.section["id"].toString());
    username_student = TextEditingController(text: widget.asignation.username_student["id"].toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Editar Asignacion")
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
        child: AsignationForm(
          formKey: formKey,
          section: section,
          username_student: username_student,
          newRow: false,
        ),
      ),
    );
  }
}
