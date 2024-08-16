import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board/controllers/task_controller.dart';

import '../views/completed_tasks.dart';

class AppBarPopup extends StatelessWidget {
  const AppBarPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case 'Refresh':
            controller.fetchTasks();
            break;
          case 'History':
            Get.to(() => const CompletedTasksScreen());
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <String>['Refresh', 'History']
            .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
