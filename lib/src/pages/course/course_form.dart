import 'package:flutter/material.dart';

class CourseForm extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController course_code;
  TextEditingController course_name;
  bool newRow;

  CourseForm({required this.formKey,required this.course_code,required this.course_name, required this.newRow});

  @override
  _CourseFormState createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          TextFormField(
            enabled: widget.newRow,
            controller: widget.course_code,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Codigo curso'),
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
            controller: widget.course_name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Nombre Curso'),
            validator: (String? value){
              if (value == null || value.isEmpty){
                return "El nombre del curso es requerido";
              }
            },
          ),
        ],
      ),
    );
  }
}
