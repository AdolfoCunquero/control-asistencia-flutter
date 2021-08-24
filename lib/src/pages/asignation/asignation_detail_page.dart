import 'package:control_asistencia/src/models/asignation_model.dart';
import 'package:control_asistencia/src/pages/asignation/asingation_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:http/http.dart' as http;

class AsignationDetailPage extends StatefulWidget {

  final Asignation asignation;
  AsignationDetailPage({required this.asignation});

  @override
  _AsignationDetailPageState createState() => _AsignationDetailPageState();
}

class _AsignationDetailPageState extends State<AsignationDetailPage> {

  void deleteAsignation(context) async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    await http.delete(Uri.parse("${URL_BASE.Env.url_base}asignation/${widget.asignation.id}/"),
        headers: {
          "Authorization": accessToken
        });
    // Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Esta seguro de eliminar esta asignacion'),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancelar"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Aceptar"),
              onPressed: () => deleteAsignation(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Asignacion'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => confirmDelete(context),
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${widget.asignation.username_student["carnet"]} ${widget.asignation.username_student["first_name"]} ${widget.asignation.username_student["last_name"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Estudiante"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.asignation.section["course_code"]["course_code"]} ${widget.asignation.section["course_code"]["course_name"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Año"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.asignation.section["section"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Seccion"),
                    ),
                    ListTile(
                      title: Text(
                        "${widget.asignation.section["start_time"]} A ${widget.asignation.section["end_time"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Horario"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.asignation.section["username_professor"]["first_name"]} ${widget.asignation.section["username_professor"]["last_name"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Catedratico"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.asignation.section["semester"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Semestre"),
                    ),
                  ],
                ),
              ]
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AsignationEditPage(asignation: widget.asignation),
          ),
        ),
      ),
    );
  }
}
