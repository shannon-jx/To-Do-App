import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/widgets/to_do_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final useremail = FirebaseAuth.instance.currentUser?.email;
  List<ToDo> toDoList = ToDo.toDoList();
  List<ToDo> _foundToDo = [];
  final _addController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    _foundToDo = toDoList;
    super.initState();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
            child: Align(
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
                  child: StreamBuilder<List<ToDo>>(
                    stream: readData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('ERROR');
                      } else if (snapshot.hasData) {
                        toDoList = snapshot.data!;
                        return ListView(
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
                                useremail: useremail!,
                                todo: todoo,
                                changeIsDone: !todoo.isDone,
                              ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
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
                    ToDo item = ToDo(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      toDoText: _addController.text
                    );
                    addItem(item: item);
                    _addController.clear();
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
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.deepPurpleAccent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: AssetImage(
                'assets/avatar.jpg',
              ),
              height: 35.0,
            ),
          ),
          Image(
            image: AssetImage(
              'assets/logo.png',
            ),
            height: 25.0,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black,),
            onPressed: signUserOut,
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
        controller: _searchController,
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

  Future addItem({required ToDo item}) async {
    toDoList.add(item);
    final docToDo = FirebaseFirestore.instance.collection(useremail!).doc(item.id);

    final json = {
      'id': item.id,
      'toDoText': item.toDoText,
      'isDone' : item.isDone,
    };
    
    await docToDo.set(json);
  }

  Stream<List<ToDo>> readData() => FirebaseFirestore.instance
    .collection(useremail!)
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => ToDo.fromJson(doc.data())).toList());

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
