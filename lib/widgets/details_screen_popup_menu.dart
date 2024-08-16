import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';
import '../utils/helper_functions.dart';
import '../views/add_task_modal.dart';

class TaskOptionsPopup extends StatelessWidget {
  final Task task;
  final TaskController taskController = Get.find<TaskController>();

  TaskOptionsPopup({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) async {
        switch (value) {
          case 'Edit':
            _showEditDialog(context, task);
            break;
          case 'Complete':
            await _completeTask(context, task);
            break;
          case 'Delete':
            await _deleteTask(context, task);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'Edit',
            child: Text('Edit Task'),
          ),
          if (task.status == 'Done')
            const PopupMenuItem<String>(
              value: 'Complete',
              child: Text('Complete Task'),
            ),
          const PopupMenuItem<String>(
            value: 'Delete',
            child: Text('Delete Task'),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert),
    );
  }

  void _showEditDialog(BuildContext context, Task task) {
    Get.dialog(
      barrierDismissible: false,
      TaskModal(
        task: task,
      ),
    );
  }

  Future<void> _completeTask(BuildContext context, Task task) async {
    bool confirmed = await Get.dialog(AlertDialog(
      title: const Text('Confirm Complete'),
      content: const Text('Are you sure you want to complete this task?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Complete'),
        ),
      ],
    ));

    if(confirmed){
      String? result = await taskController.completeTask(task);
      if ((result ?? "").isNotEmpty) {
        showToast(result!);
        return;
      }
      Get.back();
      showToast('Task marked as completed');
    }

  }

  Future<void> _deleteTask(BuildContext context, Task task) async {
    bool confirmed = await Get.dialog(AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Delete'),
        ),
      ],
    ));

    if (confirmed) {
      String? result = await taskController.deleteTask(task);
      if ((result ?? "").isNotEmpty) {
        showToast(result!);
      }
      Get.back();
    }
  }
}
