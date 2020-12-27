import 'package:flutter/material.dart';
import 'src/screens/home.dart';
import 'src/components/theme.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  ThemeData theme = lightTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: theme,
      home: MyHomePage()
    );
  }
}



