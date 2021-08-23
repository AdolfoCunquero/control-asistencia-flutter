import 'package:control_asistencia/src/models/section_model.dart';
import 'package:control_asistencia/src/pages/section/section_add_page.dart';
import 'package:control_asistencia/src/pages/section/section_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;

class SectionPage extends StatefulWidget {
  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {

  var sections;

  @override
  void initState() {
    super.initState();
    sections = getSections();
  }

  Future<List<Section>> getSections() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}section/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Section> sections = items.map<Section>((json) {
        return Section.fromJson(json);
      }).toList();
      return sections;
    } else {
      throw Exception('Failed to load Courses');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secciones"),
      ),
      body: Container(
        child: FutureBuilder<List<Section>>(
          future: sections,
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
                      "${data.course_code['course_code']} - ${data.section}",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        "${data.semester} Semestre - ${data.course_code["course_name"]}"
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> SectionDetailPage(section: data)
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
            return SectionAddPage();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

