import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/pages/course/course_edit_page.dart';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/models/course_model.dart';
import 'package:http/http.dart' as http;

class CourseDetailPage extends StatefulWidget {
  @override
  final Course course;
  CourseDetailPage({required this.course});
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {

  void deleteCourse(context) async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    await http.delete(Uri.parse("${URL_BASE.Env.url_base}course/${widget.course.course_code}/"),
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
          content: Text('Esta seguro de eliminar este curso'),
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
              onPressed: () => deleteCourse(context),
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
        title: Text('Detalle de Curso'),
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
                widget.course.course_code,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text("Codigo del curso"),
            ),
            Divider(),
            ListTile(
              title: Text(
                widget.course.course_name,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text("Nombre del curso"),
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => CourseEditPage(course: widget.course),
          ),
        ),
      ),
    );
  }
}
