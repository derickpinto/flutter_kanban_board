import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/constants/app_color.dart';
import 'package:kanban_board/constants/app_string.dart';
import 'package:kanban_board/service_injection.dart';
import 'package:kanban_board/widgets/appbar_popupmenu.dart';
import 'package:kanban_board/widgets/status_header.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import '../models/task.dart';
import 'add_task_modal.dart';
import 'task_details.dart';

class KanbanBoard extends StatelessWidget {
  final TaskController controller = Get.put(getIt<TaskController>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KANBAN BOARD',
          style: GoogleFonts.inter(
              fontSize: 18.0,
              color: AppColors.mintGreen,
              fontWeight: FontWeight.bold),
        ),
        actions: const [AppBarPopup()],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTaskColumn(AppString.todoState, Colors.blue),
            _buildTaskColumn(AppString.inProgressState, Colors.orange),
            _buildTaskColumn(AppString.doneState, Colors.green),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.skyBlue,
        foregroundColor: AppColors.white,
        onPressed: () {
          Get.dialog(
            const TaskModal(),
            barrierDismissible: false,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskColumn(String status, Color color) {
    return Container(
      width: Get.width - 100,
      padding: const EdgeInsets.all(12.0),
      color: color.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => StatusHeader(
              status: status,
              count: controller.getTaskCountOfSection(status),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: DragTarget<Task>(
              onAcceptWithDetails: (details) {
                final task = details.data;
                if (task.status != status) {
                  controller.updateSection(task, status);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Obx(
                  () => ListView(
                    children: controller.tasks
                        .where((task) => task.status == status)
                        .map((task) {
                      return LongPressDraggable<Task>(
                        data: task,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Opacity(
                            opacity: 0.7,
                            child: TaskCard(task: task),
                          ),
                        ),
                        childWhenDragging: Container(),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => TaskDetails(task: task));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TaskCard(task: task),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
