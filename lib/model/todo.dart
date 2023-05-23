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
      ToDo(id: '01', toDoText: 'Sleep', isDone: true),
      ToDo(id: '02', toDoText: 'Eat dog'),
      ToDo(id: '03', toDoText: 'Play', isDone: true),
      ToDo(id: '04', toDoText: 'Snore', isDone: true),
      ToDo(id: '05', toDoText: 'Fly'),
      ToDo(id: '06', toDoText: 'Dream', isDone: true),
      ToDo(id: '07', toDoText: 'Stfu'),
    ];
  }
}