import 'package:control_asistencia/src/pages/asistencia/asistencia_page.dart';
import 'package:control_asistencia/src/pages/professor/professor_page.dart';
import 'package:control_asistencia/src/pages/statistics/statistics_detail_page.dart';
import 'package:control_asistencia/src/pages/statistics/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:control_asistencia/src/pages/login_page.dart';
import 'package:control_asistencia/src/pages/asignation/asignation_page.dart';
import 'package:control_asistencia/src/pages/course/course_page.dart';
import 'package:control_asistencia/src/pages/section/section_page.dart';
import 'package:control_asistencia/src/pages/students/student_page.dart';
import 'package:control_asistencia/src/pages/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/': (BuildContext context)=> HomePage(),
    'course': (BuildContext context)=> CoursePage(),
    'section': (BuildContext context)=> SectionPage(),
    'student': (BuildContext context)=> UserPage(),
    'professor': (BuildContext context)=> ProfessroPage(),
    'asignation': (BuildContext context)=> AsignationPage(),
    'login': (BuildContext context)=> LoginPage(),
    'asistencia': (BuildContext context)=> AsistenciaPage(),
    'statistics':(BuildContext context)=> StatisticsPage(),
    'statistics_detail' :(BuildContext context)=> StatisticsDetailPage(),
  };
}