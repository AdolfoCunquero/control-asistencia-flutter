import 'package:control_asistencia/src/models/course_model.dart';
import 'package:control_asistencia/src/pages/course/course_add_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import './course_detail_page.dart';


class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {

  var courses;

  @override
  void initState() {
    super.initState();
    courses = getCourses();
  }

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}course/'));
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Course> courses = items.map<Course>((json) {
        return Course.fromJson(json);
      }).toList();
      return courses;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cursos"),
      ),
      body: Container(
        child: FutureBuilder<List<Course>>(
          future: courses,
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
                    data.course_name,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    data.course_code
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=> CourseDetailPage(course: data)
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
            return CourseAddPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }

}
