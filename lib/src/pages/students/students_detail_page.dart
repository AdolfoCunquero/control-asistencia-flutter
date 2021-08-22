import 'package:control_asistencia/src/pages/students/student_edit_page.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/pages/course/course_edit_page.dart';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/models/student_model.dart';
import 'package:http/http.dart' as http;

class StudentDetailPage extends StatefulWidget {

  final Student student;
  StudentDetailPage({required this.student});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {

  void deleteStudent(context) async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    await http.delete(Uri.parse("${URL_BASE.Env.url_base}auth/update/${widget.student.id}/"),
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
          content: Text('Esta seguro de eliminar este estudiante'),
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
              onPressed: () => deleteStudent(context),
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
        title: Text('Detalle de Estudiante'),
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
                    widget.student.carnet,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Carnet"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.student.username,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Username"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.student.email,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Email"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.student.first_name,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Nombres"),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    widget.student.last_name,
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
            builder: (BuildContext context) => StudentEditPage(student: widget.student),
          ),
        ),
      ),
    );
  }
}
