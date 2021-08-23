import 'package:control_asistencia/src/models/section_model.dart';
import 'package:control_asistencia/src/pages/section/section_edit_page.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:http/http.dart' as http;


class SectionDetailPage extends StatefulWidget {
  final Section section;
  SectionDetailPage({required this.section});

  @override
  _SectionDetailPageState createState() => _SectionDetailPageState();
}

class _SectionDetailPageState extends State<SectionDetailPage> {

  void deleteSection(context) async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    await http.delete(Uri.parse("${URL_BASE.Env.url_base}section/${widget.section.id}/"),
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
          content: Text('Esta seguro de eliminar esta seccion'),
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
              onPressed: () => deleteSection(context),
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
        title: Text('Detalle de Seccion'),
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
                        widget.section.semester.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Semestre"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        widget.section.year.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Año"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.section.course_code["course_code"]} - ${widget.section.course_code["course_name"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Curso"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        widget.section.section,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Seccion"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.section.start_time} A ${widget.section.end_time}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Horario"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "${widget.section.username_professor["first_name"]} ${widget.section.username_professor["last_name"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Catedratico"),
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
            builder: (BuildContext context) => SectionEditPage(section: widget.section),
          ),
        ),
      ),
    );
  }
}
