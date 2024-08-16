import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/constants/app_color.dart';
import 'package:kanban_board/controllers/completed_task_controller.dart';
import '../models/task.dart';
import 'comment_section.dart';

class CompletedTaskDetails extends StatelessWidget {
  final Task task;

  const CompletedTaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompletedTasksController>(
      tag: "completed_task_controller",
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Task Details'),
        elevation: 5,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          controller.completedTasks.refresh();
        },
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Container(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildTitle(task),
                      const Divider(thickness: 1, color: AppColors.lightGray),
                      const SizedBox(height: 16),
                      _buildRichText('Created on: ', task.getFormattedDate()),
                      const SizedBox(height: 8),
                      _buildDescriptionText(task.description),
                      const SizedBox(height: 8),
                      _buildRichText('Total time since creation: ',
                          task.getTotalTimeSinceCreation()),
                      const SizedBox(height: 8),
                      _buildRichText(
                          'Total time spent: ', task.getTotalTimeSpent()),
                      const SizedBox(height: 16),
                      CommentSection(task: task,isComplete: true,)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
}
