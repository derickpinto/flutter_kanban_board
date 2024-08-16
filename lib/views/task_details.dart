import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_color.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';
import '../widgets/details_screen_popup_menu.dart';
import '../widgets/status_menu.dart';
import 'comment_section.dart';

class TaskDetails extends StatelessWidget {
  final Task task;

  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Task Details'),
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: taskController.tasks.refresh,
          ),
          TaskOptionsPopup(task: task),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          taskController.tasks.refresh();
        },
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: SingleChildScrollView(
              child: GetX<TaskController>(
                builder: (controller) {
                  final currentTask = controller.getTaskById(task.id);

                  if (currentTask.status.isEmpty) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(currentTask),
                            const Divider(
                                thickness: 1, color: AppColors.lightGray),
                            const SizedBox(height: 16),
                            _buildRichText(
                                'Created on: ', currentTask.getFormattedDate()),
                            const SizedBox(height: 8),
                            _buildDescriptionText(currentTask.description),
                            const SizedBox(height: 8),
                            _buildRichText('Total time since creation: ',
                                currentTask.getTotalTimeSinceCreation()),
                            const SizedBox(height: 8),
                            _buildRichText('Total time spent: ',
                                currentTask.getTotalTimeSpent()),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                TaskStatusMenu(
                                  currentStatus: currentTask.status,
                                  onStatusChanged: (newStatus) {
                                    if (newStatus != currentTask.status) {
                                      taskController.updateSection(
                                          currentTask, newStatus);
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                _buildStartTime(currentTask, taskController)
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CommentSection(task: currentTask),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTitle(Task currentTask) {
    return Text(
      currentTask.title,
      style: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.inter(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(String? description) {
    String text =
        (description ?? "").isEmpty ? "No Description" : description.toString();
    return Text(
      text,
      style: GoogleFonts.inter(
        color: (description ?? "").isEmpty
            ? AppColors.mediumGray
            : AppColors.secondaryText,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStartTime(Task currentTask, TaskController taskController) {
    return ElevatedButton.icon(
      icon: Icon(
        currentTask.isTimerRunning() ? Icons.stop : Icons.play_arrow,
        color: currentTask.isTimerRunning() ? Colors.red : Colors.green,
      ),
      onPressed: () {
        if (currentTask.isTimerRunning()) {
          taskController.stopTaskTimer(currentTask);
        } else {
          taskController.startTaskTimer(currentTask);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        side: BorderSide(
          width: 1,
          color: currentTask.isTimerRunning() ? Colors.red : Colors.green,
        ),
      ),
      label: Text(
        currentTask.isTimerRunning() ? 'Stop Timer' : 'Start Timer',
        style: GoogleFonts.inter(
          color: currentTask.isTimerRunning() ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
