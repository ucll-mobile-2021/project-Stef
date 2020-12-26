import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:todo_app/src/model/model.dart';
import 'package:intl/intl.dart';

List<Color> colorList = [
  Colors.blue,
  Colors.green,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.teal,
  Colors.amber.shade900,
  Colors.deepOrange
];

class TodoCard extends StatelessWidget {
  final TodoModel todoData;
  final Function(TodoModel todoModel) onTapAction;

  const TodoCard({this.todoData, this.onTapAction});

  @override
  Widget build(BuildContext context) {
    String cleanDate = DateFormat.yMMMd().format(todoData.dueDate);
    Color color = colorList.elementAt(todoData.title.length % colorList.length);
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
                      fontSize: 20,
                      fontWeight: todoData.completed
                          ? FontWeight.w800
                          : FontWeight.normal),
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
                      Icon(Icons.flag,
                          size: 16,
                          color:
                              todoData.completed ? color : Colors.transparent),
                      Spacer(),
                      Text(
                        '$cleanDate',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade300,
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
