import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class _MenuProvider {
  List<dynamic> opciones = [];

  _MenuProvider(){}

  Future<List<dynamic>> cargarData(int rol) async {
    final resp = await rootBundle.loadString('data/menu.json');
    Map dataMap = json.decode(resp);

    opciones = dataMap["rutas_admin"];

    /*if (rol ==1){
      opciones = dataMap["rutas_admin"];
    }else if(rol == 2){
      opciones = dataMap["rutas_student"];
    }else if(rol == 3){
      opciones = dataMap["rutas_student"];
    }
    */


    return opciones;
  }

}

final menuProvider = new _MenuProvider();