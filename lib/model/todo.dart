class ToDo {
  String? id;
  String? toDoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.toDoText,
    this.isDone = false
  });

  static List<ToDo> toDoList() {
    return [
      
    ];
  }

  static ToDo fromJson(Map<String, dynamic> json) => ToDo(
    id: json['id'],
    toDoText: json['toDoText'],
    isDone: json['isDone'],
  );
}