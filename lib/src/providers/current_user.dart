import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class _CurrentUserProvider {
  Map<String, dynamic> user = {};

  _CurrentUserProvider(){}

  Future<Map<String, dynamic>> cargarData() async {
    final resp = await rootBundle.loadString('data/current_user.json');
    Map dataMap = json.decode(resp);
    user = dataMap["user_data"];
    return user;
  }
}

final userProvider = new _CurrentUserProvider();