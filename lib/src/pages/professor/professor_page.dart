import 'package:control_asistencia/src/models/professor_model.dart';
import 'package:control_asistencia/src/pages/professor/professor_add_page.dart';
import 'package:control_asistencia/src/pages/professor/professor_detail_page.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class ProfessroPage extends StatefulWidget {
  @override
  _ProfessroPageState createState() => _ProfessroPageState();
}

class _ProfessroPageState extends State<ProfessroPage> {

  var professors;

  @override
  void initState() {
    super.initState();
    professors = getProfessors();
  }

  Future<List<Professor>> getProfessors() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}users/?rol__id=2'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Professor> professors = items.map<Professor>((json) {
        return Professor.fromJson(json);
      }).toList();
      return professors;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catedraticos"),
      ),
      body: Container(
        child: FutureBuilder<List<Professor>>(
          future: professors,
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      "${data.first_name} ${data.last_name}",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        "${data.username}"
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> ProfessorDetailPage(professor: data)
                          )
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProfessorAddPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }


}
