class Todo {
  int id;
  String title;
  bool isCompleted;

  Todo({required this.id, required this.title, required this.isCompleted});

  factory Todo.fromJson(Map json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map toJson() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }
}
