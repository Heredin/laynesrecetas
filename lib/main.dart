import 'package:flutter/material.dart';
import 'package:laynes_recetas/ui/viewpage.dart';


void main() => runApp(MyAppInicio());


class MyAppInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ingresar a Recetas',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyApp(),
    );
  }
}