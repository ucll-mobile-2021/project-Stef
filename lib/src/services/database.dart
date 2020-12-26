import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/src/model/model.dart';


class TodoDatabaseService {
  String path;

  TodoDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'todo.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Todo (_id INTEGER PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, completed INTEGER');
        });
  }

  Future<List<TodoModel>> getTodoFromDB() async {
    final db = await database;
    List<TodoModel> todoList = [];
    List<Map> maps = await db.query('Todo',
        columns: ['_id', 'title', 'description', 'dueDate', 'completed']);
    if (maps.length > 0)
      maps.forEach((map) {
        todoList.add(TodoModel.fromMap(map));
      });
    return todoList;
  }

  updateTodoInDB(TodoModel updatedTodo) async {
    final db = await database;
    await db.update('Todo', updatedTodo.toMap(),
        where: '_id = ?', whereArgs: [updatedTodo.id]);
  }

  deleteTodoInDB(TodoModel toDelete) async {
    final db = await database;
    await db.delete('Todo', where: '_id = ?', whereArgs: [toDelete.id]);
  }

  Future<TodoModel> addTodoInDB(TodoModel newTodo) async {
    final db = await database;
    if (newTodo.title
        .trim()
        .isEmpty) newTodo.title = 'Untitled';
    int id = await db.transaction((txn) {
      txn.rawInsert(
          'INSERT into Todo(title, description, dueDate, completed) VALUES ('
              '"${newTodo.title}","${newTodo.description}","${newTodo.dueDate
              .toIso8601String()}","${newTodo.completed == true ? 1 : 0}";');
      });
    newTodo.id = id;
    return newTodo;
  }


}