import 'package:control_asistencia/src/models/course_model.dart';
import 'package:control_asistencia/src/models/professor_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/providers/current_user.dart';
import 'dart:convert';

class SectionForm extends StatefulWidget {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? id;
  TextEditingController section;
  TextEditingController year;
  TextEditingController course_code;
  TextEditingController start_time;
  TextEditingController end_time;
  TextEditingController username_professor;
  TextEditingController semester;
  bool newRow;

  SectionForm({
    required this.formKey,
    this.id,
    required this.section,
    required this.year,
    required this.course_code,
    required this.start_time,
    required this.end_time,
    required this.username_professor,
    required this.semester,
    required this.newRow,
  });

  @override
  _SectionFormState createState() => _SectionFormState();
}

class _SectionFormState extends State<SectionForm> {

  var professors;
  var courses;
  int? username_professor;
  String? course_code;

  Future<List<Professor>> getProfessors() async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}users/?rol__id=2'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Professor> professorsResponse = items.map<Professor>((json) {
        return Professor.fromJson(json);
      }).toList();
      setState(() {
        professors = professorsResponse;
      });
      print("Catedaticos cargados");
      return professorsResponse;

    } else {
      throw Exception('Failed to load Courses');
    }
  }

  Future<List<Course>> getCourses() async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}course/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Course> courseResponse = items.map<Course>((json) {
        return Course.fromJson(json);
      }).toList();
      setState(() {
        courses = courseResponse;
      });
      print("Cursos cargados");
      return courseResponse;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.newRow){
      username_professor = null;
      course_code = null;
    }else{
      username_professor = int.parse(widget.username_professor.text);
      course_code = widget.course_code.text;
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
          TextFormField(
            controller: widget.year,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Año'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El año es necesario";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.section,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Seccion'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "La seccion es requerida";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          FutureBuilder(
              future: getCourses(),
              initialData: [],
              builder:(BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  child: DropdownButton(
                    items: snapshot.data.map<DropdownMenuItem<String>>((item){
                      return new DropdownMenuItem<String>(
                        child: Text("${item.course_code} ${item.course_name}"),
                        value: item.course_code,
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        course_code = value.toString();
                        widget.course_code.text = course_code.toString();
                      });
                    },
                    value: course_code,
                  ),
                );
              }
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.start_time,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Hora inicio'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "La hora de inicio  es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.end_time,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Hora Fin'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "La hora fin es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          FutureBuilder(
            future: getProfessors(),
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
                        child: Text("${item.first_name} ${item.last_name}"),
                        value: item.id,
                      );
                    }).toList(),
                  onChanged: (value){
                    setState(() {
                      username_professor = int.parse(value.toString());
                      widget.username_professor.text = username_professor.toString();
                    });
                  },
                  value: username_professor,
                ),
              );
            }
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.semester,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Semestre"),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El numero de semestre es requerido";
              }
            },
          ),
        ],
      ),
    );
  }
}
