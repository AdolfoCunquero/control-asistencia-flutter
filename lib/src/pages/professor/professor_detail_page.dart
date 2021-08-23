import 'package:control_asistencia/src/models/professor_model.dart';
import 'package:control_asistencia/src/pages/professor/professor_edit_page.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:http/http.dart' as http;

class ProfessorDetailPage extends StatefulWidget {

  final Professor professor;
  ProfessorDetailPage({required this.professor});

  @override
  _ProfessorDetailPageState createState() => _ProfessorDetailPageState();
}

class _ProfessorDetailPageState extends State<ProfessorDetailPage> {

  void deleteProfessor(context) async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    await http.delete(Uri.parse("${URL_BASE.Env.url_base}auth/update/${widget.professor.id}/"),
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
          content: Text('Esta seguro de eliminar este catedratico'),
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
              onPressed: () => deleteProfessor(context),
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
        title: Text('Detalle de Catedratico'),
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
                ListTile(
                  title: Text(
                    widget.professor.username,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Username"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.professor.email,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Email"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.professor.first_name,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Nombres"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.professor.last_name,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Apellidos"),
                ),
              ]
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProfessorEditPage(professor: widget.professor),
          ),
        ),
      ),
    );
  }

}
