import 'package:control_asistencia/src/models/section_model.dart';
import 'package:control_asistencia/src/models/statistics_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StatisticsDetailPage extends StatefulWidget {
  @override
  _StatisticsDetailPageState createState() => _StatisticsDetailPageState();
}

class _StatisticsDetailPageState extends State<StatisticsDetailPage> {

  var sections;
  var statistics;
  int? section_id;
  String? fecha;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  Future<List<Section>> getSections() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}section/professor/'),
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


  Future<List<StatisticDetailsModel>> getStatistics() async {

    if(section_id == null || _selectedDate == ''){
      return [];
    }

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}statistics/por_estudiante/${section_id}/${_selectedDate}/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<StatisticDetailsModel> statisticResponse = items.map<StatisticDetailsModel>((json) {
        return StatisticDetailsModel.fromJson(json);
      }).toList();
      return statisticResponse;
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        final format = new DateFormat('yyyy-MM-dd');
        _selectedDate = args.value.toString();
        _selectedDate = format.format(DateTime.parse(_selectedDate));

        if(section_id != null && _selectedDate != ''){
          statistics = getStatistics();
        }

      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Widget asistenciaMarcada(String? date){
    if (date == null){
      return Icon(Icons.cancel_outlined, color: Colors.redAccent,);
    }else{
      return Icon(Icons.check_circle, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle estudiantes"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          children: <Widget>[
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
                          child: Text("${item.course_code["course_code"]}-${item.section} ${item.course_code["course_name"]}"),
                          value: item.id,
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          section_id = int.parse(value.toString());
                          print(section_id);
                          if(section_id != null && _selectedDate != ''){
                            //graficarPie();
                            print('entra');
                            setState(() {
                              statistics = getStatistics();
                            });
                          }
                        });
                      },
                      value: section_id,
                    ),
                  );
                }
            ),
            SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
            FutureBuilder<List<StatisticDetailsModel>>(
              future: statistics,
              //initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: Text("Seleccione curso y fecha"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    var data = snapshot.data[index];
                    return Card(
                      child: ListTile(
                        trailing: asistenciaMarcada(data.date),
                        leading: Icon(Icons.person),
                        title: Text(
                          "${data.carnet} ${data.first_name} ${data.last_name}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

          ],
        ),

      ),
    );
  }
}
