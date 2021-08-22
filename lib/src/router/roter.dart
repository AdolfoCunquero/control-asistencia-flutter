import 'package:flutter/material.dart';
import 'package:control_asistencia/src/pages/login_page.dart';
import 'package:control_asistencia/src/pages/asignation_page.dart';
import 'package:control_asistencia/src/pages/course/course_page.dart';
import 'package:control_asistencia/src/pages/section_page.dart';
import 'package:control_asistencia/src/pages/students/student_page.dart';
import 'package:control_asistencia/src/pages/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/': (BuildContext context)=> HomePage(),
    'course': (BuildContext context)=> CoursePage(),
    'section': (BuildContext context)=> SectionPage(),
    'user': (BuildContext context)=> UserPage(),
    'asignation': (BuildContext context)=> AsignationPage(),
    'login': (BuildContext context)=> LoginPage(),

  };
}