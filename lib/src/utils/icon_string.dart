import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'course': Icons.featured_play_list_rounded,
  'section': Icons.widgets,
  'user': Icons.account_circle,
  'professor': Icons.verified_user,
  'asignation': Icons.article_sharp,
  'asistencia': Icons.sports_handball,
  'statistics': Icons.pie_chart,
  'statistics_detail': Icons.list_alt
};

Icon getIcon(String name){
  return Icon(_icons[name], color: Colors.blue);
}