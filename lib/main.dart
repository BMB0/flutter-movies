import 'package:flutter/material.dart';
import 'package:movies/movies.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Movies(),
      routes: {
        '/movies': (context) => Movies(),
      },
    );
  }
}
