import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/widgets/to_do_item.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final toDoList = ToDo.toDoList();
  List<ToDo> _foundToDo = [];
  final _addController = TextEditingController();

  @override
  void initState() {
    _foundToDo = toDoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Colors.deepPurpleAccent,
            ),
            height: 330,
            padding: const EdgeInsets.only(
              left: 30,
              bottom: 90,
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Welcome Back, Shannon.',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 200,
              bottom: 70,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 30,
                  ),
                ),
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 70,
                          bottom: 20,
                        ),
                        child: const Text(
                          "Tasks for Today: ",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleChange,
                          onDeleteItem: _handleDelete,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _addController,
                    decoration: const InputDecoration(
                      hintText: 'Create New Item',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: FloatingActionButton(
                  elevation: 30,
                  onPressed: () {
                    _addItem(_addController.text);
                  },
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.deepPurpleAccent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 30,
          ),
          const Text(
            'To Do List',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/avatar.jpg'),
            ),
          )
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _filter(value),
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  void _handleChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleDelete(String id) {
    setState(() {
      toDoList.removeWhere((item) => item.id == id);
    });
  }

  void _addItem(String desc) {
    setState(() {
      toDoList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          toDoText: desc));
    });
    _addController.clear();
  }

  void _filter(String keyword) {
    List<ToDo> results = [];
    if (keyword.isEmpty) {
      results = toDoList;
    } else {
      results = toDoList
          .where((item) =>
              item.toDoText!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }
}
