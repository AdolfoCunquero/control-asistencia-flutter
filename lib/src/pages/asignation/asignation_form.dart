import 'package:control_asistencia/src/models/section_model.dart';
import 'package:control_asistencia/src/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/providers/current_user.dart';
import 'dart:convert';

class AsignationForm extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? id ;
  TextEditingController section;
  TextEditingController username_student;
  bool newRow;

  AsignationForm({
    required this.formKey,
    this.id,
    required this.section,
    required this.username_student,
    required this.newRow
  });

  @override
  _AsignationFormState createState() => _AsignationFormState();
}

class _AsignationFormState extends State<AsignationForm> {

  var sections;
  var students;

  int? section;
  int? username_student;

  Future<List<Section>> getSections() async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}section/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Section> sectionResponse = items.map<Section>((json) {
        return Section.fromJson(json);
      }).toList();
      setState(() {
        sections = sectionResponse;
      });
      print("Secciones cargadas");
      return sectionResponse;
    } else {
      throw Exception('Failed to load Courses');
    }
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
      List<Student> studentResponse = items.map<Student>((json) {
        return Student.fromJson(json);
      }).toList();
      setState(() {
        students = studentResponse;
      });
      print("Estudiantes cargados");
      return studentResponse;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.newRow){
      section = null;
      username_student = null;
    }else{
      section = int.parse(widget.section.text);
      username_student = int.parse(widget.username_student.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          FutureBuilder(
              future: getStudents(),
              initialData: [],
              builder:(BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  child: DropdownButton(
                    items: snapshot.data.map<DropdownMenuItem<int>>((item){
                      return new DropdownMenuItem<int>(
                        child: Text("${item.carnet} ${item.first_name} ${item.last_name}"),
                        value: item.id,
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        username_student = int.parse(value.toString());
                        widget.username_student.text = username_student.toString();
                      });
                    },
                    value: username_student,
                  ),
                );
              }
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          FutureBuilder(
              future: getSections(),
              initialData: [],
              builder:(BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  child: DropdownButton(
                    items: snapshot.data.map<DropdownMenuItem<int>>((item){
                      return new DropdownMenuItem<int>(
                        child: Text("${item.course_code["course_code"]} ${item.section} ${item.course_code["course_name"]}"),
                        value: item.id,
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        section = int.parse(value.toString());
                        widget.section.text = section.toString();
                      });
                    },
                    value: section,
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}
