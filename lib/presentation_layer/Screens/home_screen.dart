import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/business_logic_lauyer/shared/app_cubit.dart';
import 'package:to_do/presentation_layer/Screens/archeive_atsks/archeive_screen.dart';
import 'package:to_do/presentation_layer/Screens/done_tasks/done_screen.dart';
import 'package:to_do/presentation_layer/Screens/new_tasks/new_tasks_screen.dart';
import 'package:to_do/presentation_layer/widgets/SharedWidgets%20-%20Copy.dart';
import 'package:to_do/presentation_layer/widgets/constants.dart';

class HomeLayout extends StatelessWidget {
  Future insertValue;


  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context)
  {
    // AppCubit appCubit = AppCubit.get(context);
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
            BlocProvider.of<AppCubit>(context).setDefault(title: titleController.text, time: timeController.text, date: dateController.text);
          }
        },
        builder: (BuildContext context,AppStates state){
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('ToDo '),
              elevation: 0.0,
              //centerTitle: true,
            ),

            //TODO:AppGetDataBaseLoadingState
            body: BlocProvider.of<AppCubit>(context).tasks.length==0?const Center(child:  CircularProgressIndicator()):BlocProvider.of<AppCubit>(context).screens[BlocProvider.of<AppCubit>(context).currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isBottomSheetShown) {
                  BlocProvider.of<AppCubit>(context).insertToDataBase(
                    time: timeController.text,
                    date: dateController.text,
                    title: titleController.text,
                  ).then((value) {
                    print('insert Done');
                  });
                  BlocProvider.of<AppCubit>(context).getDataFromDatabase(BlocProvider.of<AppCubit>(context).database).then((value){
                    BlocProvider.of<AppCubit>(context).tasks = value;
                    //Navigator.pop(context);
                    print('get news data');
                    isBottomSheetShown = !isBottomSheetShown;
                    BlocProvider.of<AppCubit>(context).changeBottomSheetState(isShow: false, icon: Icons.edit);
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });

                } else {
                  scaffoldKey.currentState?.showBottomSheet((context) => Container(
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
                                        value.format(context).toString();
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
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-12-22'),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
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
                  BlocProvider.of<AppCubit>(context).changeBottomSheetState(isShow: true, icon: Icons.add);
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(BlocProvider.of<AppCubit>(context).fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archived')
                ],
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                BlocProvider.of<AppCubit>(context).changeIndex(index);
              },
              currentIndex: BlocProvider.of<AppCubit>(context).currentIndex,
            ),
          );
        },

      ),
    );
  }


}
