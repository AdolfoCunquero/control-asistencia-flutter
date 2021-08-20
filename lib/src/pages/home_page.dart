import 'package:flutter/material.dart';
import 'package:control_asistencia/src/providers/menu_provider.dart';
import 'package:control_asistencia/src/utils/icon_string.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu principal"),
      ),
      body: _lista(),
    );
  }

  Widget _lista(){
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        return ListView(
          padding: EdgeInsets.all(10.0),
          children: _crearListaItems(snapshot.data, context),
        );
      },
    );
  }

  List<Widget> _crearListaItems( data,BuildContext context){
    final List<Widget> opciones = [];
    data.forEach((item) {
      final widgetTemp2 = Card(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child:ListTile(
            title: Text(item["texto"]),
            leading: getIcon(item["icon"]),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
            onTap: (){
              Navigator.pushNamed(context, item["ruta"]);
            },
          )
        ),
      );
      final widgetTemp = ListTile(
        title: Text(item["texto"]),
        leading: getIcon(item["icon"]),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
        onTap: (){
          Navigator.pushNamed(context, item["ruta"]);
        },
      );
      opciones.add(widgetTemp2);
    });

    return opciones;
  }

}
