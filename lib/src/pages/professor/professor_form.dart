import 'package:flutter/material.dart';

class ProfessorForm extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController username;
  TextEditingController email;
  TextEditingController first_name;
  TextEditingController last_name;
  TextEditingController? password;
  TextEditingController? id;
  bool newRow;

  ProfessorForm({
    required this.formKey,
    required this.email,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.newRow,
    this.password,
    this.id
  });

  @override
  _ProfessorFormState createState() => _ProfessorFormState();
}

class _ProfessorFormState extends State<ProfessorForm> {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.username,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El username es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El email es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.first_name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Nombres'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "Los nombres son requeridos";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.last_name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Apellidos'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "Los apellidos son requeridos";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            enabled: widget.newRow,
            textCapitalization: TextCapitalization.words,
            controller: widget.password,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (String? value){
              if(widget.newRow){
                if (value == null || value.isEmpty){
                  return "El password es requerido";
                }
              }
            },
          ),
        ],
      ),
    );
  }

}
