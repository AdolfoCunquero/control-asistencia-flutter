import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'course': Icons.featured_play_list_rounded,
  'section': Icons.widgets,
  'user': Icons.account_circle,
  'asignation': Icons.article_sharp
};

Icon getIcon(String name){
  return Icon(_icons[name], color: Colors.blue);
}