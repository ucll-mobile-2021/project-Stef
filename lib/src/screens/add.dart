import 'package:flutter/material.dart';
import 'package:todo_app/src/model/model.dart';
import 'package:todo_app/src/services/database.dart';

class AddForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add Task",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add New Task"),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Enter a title."),
            ),
            TextFormField(
              controller: descriptionController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Enter a description"),
            ),
            RaisedButton(
                child: Text("Enter due date."), 
                onPressed: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: new DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                      lastDate: DateTime(2025)
                  ).then((date) {
                    _dateTime = date;
                  });
                }
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  TodoModel newTodo = createTodo(titleController.text, descriptionController.text, _dateTime);
                  TodoDatabaseService.db.addTodoInDB(newTodo);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("New Todo: " + titleController.text + ": " + descriptionController.text + " due to " + _dateTime.toIso8601String())));
                }
              },
              child: Text("Submit"),
            )
          ],
        ));
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  TodoModel createTodo(String title, String description, DateTime dateTime){
    return new TodoModel(title: title, description: description, dueDate: dateTime);
  }
}
