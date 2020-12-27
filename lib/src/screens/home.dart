import "package:flutter/material.dart";
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:todo_app/src/components/TodoCards.dart';
import 'package:todo_app/src/model/model.dart';
import 'package:todo_app/src/screens/detail.dart';
import 'package:todo_app/src/screens/form.dart';
import 'package:todo_app/src/screens/settings.dart';
import 'package:todo_app/src/services/database.dart';

class MyHomePage extends StatefulWidget {
  final Function(Brightness brightness) changeTheme;

  MyHomePage({Key key, this.changeTheme}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoModel> todoList = [];

  @override
  void initState() {
    super.initState();
    TodoDatabaseService.db.init();
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
      floatingActionButton: FloatingActionButton.extended(
        // TODO colorscheme
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => goToForm(),
        label: Text(
          'Add task'.toUpperCase(),
          style:
              TextStyle(fontFamily: 'ZillaSlab', fontWeight: FontWeight.w600),
        ),
        icon: Icon(Icons.add),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Settings(changeTheme: widget.changeTheme)));
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.centerRight,
                        child: Icon(OMIcons.settings,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade300),
                      ),
                    )
                  ],
                ),
                buildHeader(context),
                ...buildTodoComponents(),
                // GestureDetector(onTap: goToForm, child: AddTodoCard()),
                Container(
                  height: 100,
                )
              ],
            ),
            margin: EdgeInsets.only(top: 2),
            padding: EdgeInsets.only(left: 15, right: 15),
          )),
    );
  }

  List<Widget> buildTodoComponents() {
    List<Widget> todoComponents = [];
    if (todoList.isEmpty) {
      todoComponents.add(PlaceholderCard());
      //todo if empty list => return place holder card (kinda like the add card)
    } else {
      todoList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      todoList.forEach((todo) {
        todoComponents.add(TodoCard(todoData: todo, onTapAction: openTodo));
      });
    }
    return todoComponents;
  }

  openTodo(TodoModel todoData) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyDetail(refetchData: refetchFromDB, current: todoData)));
  }

  void refetchFromDB() async {
    await setTodoList();
  }

  goToForm() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyForm(refetchData: refetchFromDB)));
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          child: Text(
            'Your tasks',
            style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontWeight: FontWeight.w700,
                fontSize: 36,
                color: Theme.of(context).primaryColor),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
