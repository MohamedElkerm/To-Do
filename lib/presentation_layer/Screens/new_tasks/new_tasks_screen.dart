import 'package:flutter/material.dart';
import 'package:to_do/presentation_layer/widgets/SharedWidgets%20-%20Copy.dart';
import 'package:to_do/presentation_layer/widgets/constants.dart';

class NewTasksScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(
        time: tasks[index]['time'],
        date : tasks[index]['date'],
        title : tasks[index]['title'],
      ),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0, 20.0, 0),
        child: Container(
          width: double.infinity,
          height: 0.5,
          color: Colors.teal,
        ),
      ),
      itemCount: tasks.length,
    );
  }
}
