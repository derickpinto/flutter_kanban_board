import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/completed_task_controller.dart';
import '../service_injection.dart';
import '../widgets/task_card.dart';
import 'completed_task_details.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CompletedTasksController>(
      init: getIt<CompletedTasksController>(),
      tag: "completed_task_controller",
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Completed Tasks'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.fetchCompletedTasks(),
              ),
            ],
          ),
          body: controller.completedTasks.isEmpty
              ? const Center(child: Text('No completed tasks found.'))
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: controller.completedTasks.length,
                    itemBuilder: (context, index) {
                      final task = controller.completedTasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => CompletedTaskDetails(task: task));
                          },
                          child: TaskCard(task: task),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
