import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class _MenuProvider {
  List<dynamic> opciones = [];

  _MenuProvider(){}

  Future<List<dynamic>> cargarData() async {
    final resp = await rootBundle.loadString('data/menu.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap["rutas"];

    return opciones;
  }



}

final menuProvider = new _MenuProvider();