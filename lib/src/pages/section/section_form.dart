import 'package:flutter/material.dart';

class SectionForm extends StatefulWidget {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? id;
  TextEditingController section;
  TextEditingController year;
  TextEditingController course_code;
  TextEditingController start_time;
  TextEditingController end_time;
  TextEditingController username_professor;
  TextEditingController semester;
  bool newRow;

  SectionForm({
    required this.formKey,
    this.id,
    required this.section,
    required this.year,
    required this.course_code,
    required this.start_time,
    required this.end_time,
    required this.username_professor,
    required this.semester,
    required this.newRow,
  });

  @override
  _SectionFormState createState() => _SectionFormState();
}

class _SectionFormState extends State<SectionForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          TextFormField(
            controller: widget.year,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Año'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El año es necesario";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.section,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Seccion'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "La seccion es requerida";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.course_code,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Codigo Curso'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El codigo de curso es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.start_time,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Hora inicio'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "La hora de inicio  es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.end_time,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Hora Fin'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "La hora fin es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.username_professor,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Catedratico"),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El catedratico es requerido";
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: widget.semester,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Semestre"),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El numero de semestre es requerido";
              }
            },
          ),
        ],
      ),
    );
  }
}
