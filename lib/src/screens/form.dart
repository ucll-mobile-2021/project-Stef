import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:todo_app/src/model/model.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/src/screens/home.dart';
import 'package:todo_app/src/screens/overview.dart';
import 'package:todo_app/src/services/database.dart';

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Form', home: MyForm());
  }
}

class MyForm extends StatefulWidget {
  Function() refetchData;
  TodoModel oldTodo;

  MyForm({this.refetchData, this.oldTodo});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  bool isNew = true;


  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  TodoModel currentTodo;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2025));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.oldTodo == null) {
      currentTodo =
          TodoModel(title: '', description: '', dueDate: DateTime.now());
    } else {
      currentTodo = widget.oldTodo;
      isNew = false;
    }
    titleController.text = currentTodo.title;
    descriptionController.text = currentTodo.description;
    dateController.text = DateFormat.yMMMd().format(currentTodo.dueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                focusNode: titleFocus,
                autofocus: true,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(descriptionFocus);
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: "Enter a title...",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'ZillaSlab'),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                focusNode: descriptionFocus,
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter description...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    FocusScope(
                        node: new FocusScopeNode(),
                        child: TextField(
                          controller: dateController,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter description...',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                        )),
                    RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select due date'),
                    )
                  ],
                )),
          ],
        ),
        ClipRect(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 80,
            // TODO colorscheme theme
            // color: Theme.of(context).canvasColor.withOpacity(0.3)
            child: SafeArea(
              child: Row(
                children: <Widget>[
                  // Go back
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage())
                        );
                      }),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      handleDelete();
                    },
                  ),
                  AnimatedContainer(
                      margin: EdgeInsets.only(left: 10),
                      duration: Duration(milliseconds: 200),
                      // TODO Check dirty implementation
                      width: 100,
                      height: 42,
                      curve: Curves.decelerate,
                      child: RaisedButton.icon(
                        // TODO colorscheme
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                bottomLeft: Radius.circular(100))),
                        icon: Icon(Icons.done),
                        label: Text(
                          'SAVE',
                          style: TextStyle(letterSpacing: 1),
                        ),
                        onPressed: handleSave,
                      ))
                ],
              ),
            ),
          ),
        ))
      ],
    ));
  }

  void handleDelete() {
    if (isNew){
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Delete Task'),
              content: Text('This task will be deleted permanently'),
              actions: <Widget>[
                FlatButton(
                  child: Text('DELETE',
                      style: TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    await TodoDatabaseService.db.deleteTodoInDB(currentTodo);
                    widget.refetchData();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
    });
  }}

  void handleSave() async {
    setState(() {
      currentTodo.title = titleController.text;
      currentTodo.description = descriptionController.text;
      currentTodo.dueDate = selectedDate;
    });
    if (isNew){
      var latest = await TodoDatabaseService.db.addTodoInDB(currentTodo);
      setState(() {
        currentTodo = latest;
      });
    } else {
      await TodoDatabaseService.db.updateTodoInDB(currentTodo);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Overview())
    );
  }
}
//TODO zorg dat duedate niet ge-edit kan worden