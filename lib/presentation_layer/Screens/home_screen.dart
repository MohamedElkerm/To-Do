import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/presentation_layer/Screens/archeive_atsks/archeive_screen.dart';
import 'package:to_do/presentation_layer/Screens/done_tasks/done_screen.dart';
import 'package:to_do/presentation_layer/Screens/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late Database database;
  int currentIndex = 0;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  @override
  initState() {
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do '),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archived')
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
      ),
    );
  }

  //check path(nameOfDataBase) if found onOpen only ,if not onCreate then on onOpen
  //we create the table in on create not in on open
  void createDataBase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT ,date TEXT ,time TEXT , status TEXT )')
            .then((value) {
          print('table created');
        }).catchError((err) {
          print(err.toString());
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    ).catchError((err) {
      print(err.toString());
    });
  }

  //function to insert data in table
  /*void insertToDataBase() {
    database.transaction((txn) {
      txn.rawInsert('').then((value){}).catchError((err){print(err.toString());});
      return null;
    });
  }*/
}
