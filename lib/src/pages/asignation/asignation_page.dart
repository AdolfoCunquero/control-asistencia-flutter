import 'package:control_asistencia/src/models/asignation_model.dart';
import 'package:control_asistencia/src/pages/asignation/asignation_add_page.dart';
import 'package:control_asistencia/src/pages/asignation/asignation_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class AsignationPage extends StatefulWidget {
  @override
  _AsignationPageState createState() => _AsignationPageState();
}

class _AsignationPageState extends State<AsignationPage> {
  var asignations;

  @override
  void initState() {
    super.initState();
    asignations = getAsignations();
  }

  Future<List<Asignation>> getAsignations() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}asignation/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Asignation> asignationResponse = items.map<Asignation>((json) {
        return Asignation.fromJson(json);
      }).toList();
      return asignationResponse;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asignacion de cursos"),
      ),
      body: Container(
        child: FutureBuilder<List<Asignation>>(
          future: asignations,
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      "${data.username_student['carnet']} ${data.username_student['first_name']} ${data.username_student['last_name']}",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        "${data.section['course_code']['course_code']} ${data.section['section']} - ${data.section["course_code"]["course_name"]}"
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> AsignationDetailPage(asignation: data)
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
            return AsignationAddPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }

}
