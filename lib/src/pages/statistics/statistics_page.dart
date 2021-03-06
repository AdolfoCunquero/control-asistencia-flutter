import 'package:control_asistencia/src/models/section_model.dart';
import 'package:control_asistencia/src/models/statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'package:pie_chart/pie_chart.dart';
import 'package:control_asistencia/src/providers/current_user.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StatisticsPage extends StatefulWidget {

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  Map<String, double> dataMap = new Map();
  var sections;
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


  Future<List<StatisticsModel>> getStatistics() async {

    var currentUserProvider = await userProvider.cargarData();
    final String accessToken = currentUserProvider["access_token"];

    final response = await http.get(Uri.parse('${URL_BASE.Env.url_base}statistics/por_curso/${section_id}/${_selectedDate}/'),
        headers: {
          "Authorization": accessToken
        });
    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<StatisticsModel> statisticResponse = items.map<StatisticsModel>((json) {
        return StatisticsModel.fromJson(json);
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
        graficarPie();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void graficarPie() async{
    var new_statisitcs = await getStatistics();

    setState(() {
      new_statisitcs.forEach((element) {
        dataMap[element.legend] = double.parse(element.conteo.toString());
        //dataMap["SI asistieron"] = double.parse(element.conteo.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("SI Asistieron", () => 0);
    dataMap.putIfAbsent("NO Asistieron", () => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grafico por curso"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(25.0),
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
                            graficarPie();
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
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery
                  .of(context)
                  .size
                  .width / 2.7,
            ),
          ],
        ),

      ),
    );
  }
}
