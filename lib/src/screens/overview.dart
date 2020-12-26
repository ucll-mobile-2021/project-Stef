import 'dart:async';

import "package:flutter/material.dart";
import 'package:todo_app/src/components/TodoCards.dart';
import 'package:todo_app/src/model/model.dart';
import 'package:todo_app/src/services/database.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: TodoOverview(),
      ),
    );
  }
}

class TodoOverview extends StatefulWidget {
  @override
  _TodoOverviewState createState() => _TodoOverviewState();
}

class _TodoOverviewState extends State<TodoOverview> {
  List<TodoModel> todoList = [];

  @override
  void initState() {
    TodoDatabaseService.db.init();
    super.initState();
    setTodoList();
  }

  setTodoList() async {
    var fetchedTodo = await TodoDatabaseService.db.getTodoFromDB();
    setState(() {
      todoList = fetchedTodo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[...buildTodoComponents()],
        ),
      ),
    );
  }

  List<Widget> buildTodoComponents() {
    List<Widget> todoComponents = [];
    todoList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    todoList.forEach((todo) {
      todoComponents.add(TodoCard(todoData: todo, onTapAction: openTodo));
    });
    return todoComponents;
  }

  openTodo(TodoModel todoModel) async {
    // TODO detail view
    throw UnimplementedError();
  }
}
