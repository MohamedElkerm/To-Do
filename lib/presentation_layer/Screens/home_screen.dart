import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/presentation_layer/Screens/archeive_atsks/archeive_screen.dart';
import 'package:to_do/presentation_layer/Screens/done_tasks/done_screen.dart';
import 'package:to_do/presentation_layer/Screens/new_tasks/new_tasks_screen.dart';
import 'package:to_do/presentation_layer/widgets/SharedWidgets%20-%20Copy.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late Database database;
  var insertValue;

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
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
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('ToDo '),
        elevation: 0.0,
        //centerTitle: true,
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            insertToDataBase(
              time:timeController.text,
              date:dateController.text ,
              title: titleController.text,
            );
            Navigator.pop(context);
            isBottomSheetShown = !isBottomSheetShown;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldKey.currentState?.showBottomSheet(
                    (context) => Container(
                  color: Colors.teal,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: defaultFormField(
                              controller: titleController,
                              label: 'task title',
                              type: TextInputType.text,
                              //Validation is not correct
                              // validator:(String? value)
                              // {
                              //   if(value.)
                              //   {
                              //     return 'title must not be empty';
                              //   }else
                              //   {
                              //     return null;
                              //   }
                              // } ,
                              prefix: Icons.title,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: defaultFormField(
                              controller: timeController,
                              label: 'time title',
                              type: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                              prefix: Icons.watch_later_outlined,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: defaultFormField(
                              controller: dateController,
                              label: 'date title',
                              type: TextInputType.datetime,
                              onTap: () {
                                print('object');
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-12-22'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              prefix: Icons.calendar_today,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
            isBottomSheetShown = !isBottomSheetShown;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
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
  Future insertToDataBase(
      {required String? title,
      required String? time,
      required String? date})  {
    return  database.transaction((txn){
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('inserted successfully');
      }).catchError((err) {
        print(err.toString());
      });
      return insertValue;
    });
  }
}
