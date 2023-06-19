import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final String useremail;
  final ToDo todo;
  final bool changeIsDone;
  //final onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.useremail,
    required this.todo,
    required this.changeIsDone,
    //required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          final docToDo = FirebaseFirestore.instance.collection(useremail).doc(todo.id);
          docToDo.update({
            'isDone': changeIsDone
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          todo.toDoText!,
          style: TextStyle(
            fontSize: 16,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              //onDeleteItem(todo.id);
              final docToDo = FirebaseFirestore.instance.collection(useremail).doc(todo.id);
              docToDo.delete();
            },
          ),
        ),
      ),
    );
  }
}
