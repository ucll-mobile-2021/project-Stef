import 'package:flutter/material.dart';
import 'src/screens/home.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      home: MyHomePage()
    );
  }
}



