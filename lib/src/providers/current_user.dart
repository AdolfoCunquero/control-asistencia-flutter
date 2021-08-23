import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class _CurrentUserProvider {
  Map<String, dynamic> user = {};

  _CurrentUserProvider(){}

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/current_user.json');
  }

  Future<Map<String, dynamic>> cargarData() async {
    //final resp = await rootBundle.loadString('data/current_user.json');
    //Map dataMap = json.decode(resp);
    //user = dataMap["user_data"];
    //return user;
    final file = await _localFile;
    String content = await file.readAsString();
    user = json.decode(content);
    return user;
  }
}

final userProvider = new _CurrentUserProvider();