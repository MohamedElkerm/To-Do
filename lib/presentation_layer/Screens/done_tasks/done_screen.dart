import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/business_logic_lauyer/shared/app_cubit.dart';
import 'package:to_do/presentation_layer/widgets/SharedWidgets%20-%20Copy.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(); //BlocConsumer<AppCubit,AppStates>(
    //   listener: (context,AppStates){},
    //   builder: (context,AppStates){
    //     return ListView.separated(
    //       itemBuilder: (context, index) => buildTaskItem(
    //         time: AppCubit.get(context).doneTasks[index]['time'],
    //         date : AppCubit.get(context).doneTasks[index]['date'],
    //         title : AppCubit.get(context).doneTasks[index]['title'],
    //         //id:AppCubit.get(context).tasks[index]['status'],
    //         index:index,
    //         context: context,
    //       ),
    //       separatorBuilder: (context, index) => Padding(
    //         padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0, 20.0, 0),
    //         child: Container(
    //           width: double.infinity,
    //           height: 0.5,
    //           color: Colors.teal,
    //         ),
    //       ),
    //       itemCount: AppCubit.get(context).doneTasks.length,
    //     );
    //   },
    // );
  }
}
