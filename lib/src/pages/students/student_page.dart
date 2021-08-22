import 'package:control_asistencia/src/models/student_model.dart';
import 'package:control_asistencia/src/pages/students/student_add_page.dart';
import 'package:control_asistencia/src/pages/students/students_detail_page.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  var students;

  @override
  void initState() {
    super.initState();
    students = getStudents();
  }

  Future<List<Student>> getStudents() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}users/?rol__id=3'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Student> students = items.map<Student>((json) {
        return Student.fromJson(json);
      }).toList();
      return students;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estudiantes"),
      ),
      body: Container(
        child: FutureBuilder<List<Student>>(
          future: students,
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
                        "${data.carnet}"
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> StudentDetailPage(student: data)
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
            return StudentAddPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
