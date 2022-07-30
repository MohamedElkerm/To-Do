import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:to_do/presentation_layer/Screens/archeive_atsks/archeive_screen.dart';
import 'package:to_do/presentation_layer/Screens/done_tasks/done_screen.dart';
import 'package:to_do/presentation_layer/Screens/new_tasks/new_tasks_screen.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void setDefault(
      {@required String title, @required String time, @required String date}) {
    title = '';
    time = '';
    date = '';
    emit(AppSetDefaultResultInFieldsState());
  }

  Database database;
  List<Map> tasks = [];

  //check path(nameOfDataBase) if found onOpen only ,if not onCreate then on onOpen
  //we create the table in on create not in on open
  void createDataBase() {
    openDatabase(
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
        getDataFromDatabase(database);
        print('database opened');
        print('getDataFromDatabase is doned');
      },
    ).catchError((err) {
      print(err.toString());
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  //function to insert data in table
  insertToDataBase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((err) {
        print('error is : ${err.toString()}');
      });
    });
  }

   getDataFromDatabase(database)async  {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks').then((value) {
      tasks = value;
      print(tasks);

      emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState(
      {@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({@required String status, @required  int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? Where id = ? ',
        ['$status', id]).then((value) {
          emit(AppUpdateDatabaseState());
    });
  }
}
