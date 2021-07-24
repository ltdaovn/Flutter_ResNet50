import 'predict.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Classification-Catdog',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: Predict()
    );
  }
}