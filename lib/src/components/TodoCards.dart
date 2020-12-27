import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:todo_app/src/model/model.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todoData;
  final Function(TodoModel todoModel) onTapAction;

  const TodoCard({this.todoData, this.onTapAction});

  @override
  Widget build(BuildContext context) {
    String cleanDate = DateFormat.yMMMd().format(todoData.dueDate);
    Color color = Theme.of(context).accentColor;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [buildBoxShadow(color, context)],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            onTapAction(todoData);
          },
          splashColor: color.withAlpha(20),
          highlightColor: color.withAlpha(10),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${todoData.title.trim().length <= 20 ? todoData.title.trim() : todoData.title.trim().substring(0, 20) + '...'}',
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 20),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    '${todoData.description.trim().split('\n').first.length <= 30 ? todoData.description.trim().split('\n').first : todoData.description.trim().split('\n').first.substring(0, 30) + '...'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$cleanDate',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade300,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    return BoxShadow(
        color: todoData.completed == true
            ? color.withAlpha(60)
            : color.withAlpha(25),
        blurRadius: 8,
        offset: Offset(0, 8));
  }
}

class AddTodoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Add new task',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class OverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Show Overview',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class PlaceholderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(18),
          // color: Theme.of(context).primaryColor,
          // color: Colors.red,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'There are currently no tasks',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
