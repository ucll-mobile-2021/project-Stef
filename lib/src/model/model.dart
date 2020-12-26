
class TodoModel {
  int id;
  String title;
  String description;
  DateTime dueDate;
  bool completed = false;

  TodoModel({this.id ,this.title, this.description, this.dueDate, this.completed});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'description' : this.description,
      'dueDate' : this.dueDate.toIso8601String(),
      'completed': this.completed == true ? 1 : 0
    };
  }

  TodoModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.description = map['description'];
    this.dueDate = DateTime.parse(map['dueDate']);
    this.completed = map['completed'] == 1 ? true : false;
  }



}