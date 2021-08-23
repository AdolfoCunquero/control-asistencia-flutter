import 'dart:io';
import 'package:control_asistencia/src/models/access_model.dart';
import 'package:control_asistencia/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:control_asistencia/src/env/env.dart' as URL_BASE;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginPage> {

  String _username = "";
  String _password = "";

  void obtenerDatos() async {
    final file = await _localFile;
    String content = await file.readAsString();
    print(content);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/current_user.json');
  }

  Future<File> writeCurrentUser(String user) async {
    final file = await _localFile;

    return file.writeAsString(user);
  }

  Future _validateLogin() async {
    var response =  await http.post(Uri.parse("${URL_BASE.Env.url_base}auth/login/"),
      body: {
        "username": _username,
        "password": _password,
      },
    );

    if (response.statusCode == 200){
      AccessModel login = AccessModel.fromJson(jsonDecode(response.body));

      var me =  await http.get(Uri.parse("${URL_BASE.Env.url_base}auth/me/"),
        headers: {
         "Authorization" : "Bearer ${login.access}"
        }
      );
      UserModel user_model = UserModel.fromJson(jsonDecode(me.body));
      writeCurrentUser("""
        {
          "username": "${user_model.username}",
          "rol": ${user_model.rol},
          "first_name": "${user_model.first_name}",
          "last_name": "${user_model.last_name}",
          "access_token": "Bearer ${login.access}"
         }
      """);
    }

    print('Loged in!');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Control Asistencias UMG"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 30.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: FlutterLogo()),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value){
                  _username = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Ingrese su usuario'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 25.0),
              child: TextField(
                onChanged: (value){
                  _password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Password'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  _validateLogin();
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}