import 'package:control_asistencia/src/models/asistencia_model.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:intl/intl.dart';

class AsistenciaPage extends StatefulWidget {

  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  var asignations;

  @override
  void initState() {
    super.initState();
    asignations = getAsignations();
  }

  Future<List<Asistencia>> getAsignations() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}control_asistencia/list/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Asistencia> asignationResponse = items.map<Asistencia>((json) {
        return Asistencia.fromJson(json);
      }).toList();

      return asignationResponse;
    } else {
      throw Exception('Failed to load Courses');
    }

  }

  Widget asistenciaMarcada(String? date){
    if (date == null){
      return Icon(Icons.cancel_outlined, color: Colors.redAccent,);
    }else{
      return Icon(Icons.check_circle, color: Colors.green);
    }
  }

  void marcarAsistencia(context, int id) async {
    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);

    var response =await http.post(Uri.parse("${URL_BASE.Env.url_base}control_asistencia/"),
        body: {
          "asignation": id.toString(),
          "date": currentDate
        },
        headers: {
          "Authorization": accessToken
        });

    Navigator.of(context).pop();

    setState(() {
      asignations = getAsignations();
    });

  }

  void confirmAsistencia(context, int id, String? date) {
    if(date != null){
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Marcar asistencia para este curso'),
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
              onPressed: () => marcarAsistencia(context, id),
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
        title: Text("Asistencia de hoy"),
      ),
      body: Container(
        child: FutureBuilder<List<Asistencia>>(
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
                    trailing: asistenciaMarcada(data.date),
                    title: Text(
                      "Seccion ${data.section} - ${data.course_name}",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        "${data.carnet} ${data.first_name} ${data.last_name}"
                    ),
                    onTap: (){
                      confirmAsistencia(context, data.id, data.date);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

