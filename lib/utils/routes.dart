// routes.dart
import 'package:get/get.dart';
import 'package:kanban_board/views/completed_task_details.dart';
import 'package:kanban_board/views/completed_tasks.dart';
import 'package:kanban_board/views/task_details.dart';
import 'package:kanban_board/models/task.dart';

import '../views/kanban_board.dart';

class AppRoutes {
  static const String kanbanBoard = '/';
  static const String taskDetails = '/task-details';
  static const String completeTaskListing = '/complete-task-listing';
  static const String completeTaskDetails = '/complete-task-details';

  static final List<GetPage> pages = [
    GetPage(
      name: kanbanBoard,
      page: () => KanbanBoard(),
    ),
    GetPage(
      name: taskDetails,
      page: () => TaskDetails(task: Get.arguments as Task),
    ),
    GetPage(
      name: completeTaskListing,
      page: () => const CompletedTasksScreen(),
    ),
    GetPage(
      name: completeTaskDetails,
      page: () => CompletedTaskDetails(task: Get.arguments as Task),
    ),
  ];
}
