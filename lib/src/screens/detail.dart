import 'package:flutter/material.dart';
import 'package:todo_app/src/model/model.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'package:todo_app/src/screens/form.dart';

import 'package:todo_app/src/services/database.dart';

class MyDetail extends StatefulWidget {
  final Function() refetchData;
  final TodoModel current;

  const MyDetail({this.refetchData, this.current});

  @override
  _MyDetailState createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 40.0, bottom: 16),
              child: AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Text(
                  widget.current.title,
                  style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  DateFormat.yMMMd().format(widget.current.dueDate),
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 36, bottom: 24, right: 24),
              child: Text(
                widget.current.description,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'ZillaSlab'
                ),
              ),
            )
          ],
        ),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 90,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: handleDelete,
                      ),
                      // TODO: make sharing possible
                      // IconButton(
                      //   icon: Icon(OMIcons.share),
                      //   onPressed: handleShare,
                      // ),
                      IconButton(
                        icon: Icon(OMIcons.edit),
                        onPressed: handleEdit,
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Delete Task', style: TextStyle(fontFamily: 'ZillaSlab', fontWeight: FontWeight.w600),),
            content: Text('This task will be deleted permanently', style: TextStyle(fontFamily: 'ZillaSlab'),),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontFamily: "ZillaSlab",
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  await TodoDatabaseService.db.deleteTodoInDB(widget.current);
                  widget.refetchData();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'ZillaSlab',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyForm(
                refetchData: widget.refetchData,
                existingTodo: widget.current)));
  }

  void handleBack() {
    Navigator.pop(context);
  }
}
