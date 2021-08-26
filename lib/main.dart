import 'package:flutter/material.dart';
import 'package:control_asistencia/src/pages/home_page.dart';
import 'package:control_asistencia/src/router/roter.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Menu principal",
      initialRoute: 'login',
      routes:getApplicationRoutes(),
      onGenerateRoute: (settings){
        return MaterialPageRoute(
            builder: (BuildContext context) => HomePage()
        );
      },
    );
  }
}
