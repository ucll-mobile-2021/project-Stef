import 'package:flutter/material.dart';
import 'package:todo_app/src/screens/signIn.dart';
import 'package:todo_app/src/services/themeStorage.dart';
import 'src/components/theme.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  ThemeData theme = lightTheme;

  @override
  void initState() {
    super.initState();
    updateThemeFromLocalStorage();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: theme,
      home: SignIn(changeTheme: setTheme)
    );
  }

  setTheme(Brightness brightness){
    if (brightness == Brightness.dark){
      setState(() {
        theme = darkTheme;
      });
    } else {
      setState(() {
        theme = lightTheme;
      });
    }
  }


  void updateThemeFromLocalStorage() async{
    String themeStr = await getThemeFromLocalStorage();
    if (themeStr == 'light'){
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }
}



