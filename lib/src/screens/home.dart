import "package:flutter/material.dart";
import 'package:todo_app/src/components/TodoCards.dart';
import 'package:todo_app/src/screens/add.dart';
import 'package:todo_app/src/screens/form.dart';
import 'package:todo_app/src/services/database.dart';

import 'overview.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Todo App '),
            ),
            body: HomePage()));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    TodoDatabaseService.db.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        //backgroundColor: Theme.of(context).primaryColor
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FormPage() ));
        },
        label: Text('Add note'.toUpperCase()),
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
                //Todo header
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      // TODO change AddForm to general edit/add
                      MaterialPageRoute(builder: (context) => Overview())
                    );
                  },
                  child: OverviewCard(),
                ),
              ],
            ),
          )),
    );
  }

}
