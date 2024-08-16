import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/constants/app_string.dart';
import 'package:kanban_board/utils/helper_functions.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskModal extends StatefulWidget {
  final Task? task;

  const TaskModal({Key? key, this.task}) : super(key: key);

  @override
  _TaskModalState createState() => _TaskModalState();
}

class _TaskModalState extends State<TaskModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TaskController taskController = Get.find<TaskController>();
  String status = AppString.todoState;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description ?? "";
      status = widget.task!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.task == null ? 'Add New Task' : 'Edit Task',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: titleController,
              label: 'Task Title',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descriptionController,
              label: 'Description',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _handleSubmit,
          child: Text(
            'Submit',
            style: GoogleFonts.inter(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(), // Close the modal
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      if (widget.task == null) {
        // Create a new task
        Task newTask = Task(
          id: DateTime.now().toString(),
          title: titleController.text,
          description: descriptionController.text,
          status: status,
        );

        // Call API to add task
        bool success = await taskController.addTask(newTask);
        if (success) {
          Get.back(); // Close the modal
          showToast('Task added successfully');
        } else {
          showToast('Failed to add task');
        }
      } else {
        // Update existing task
        widget.task!.updateTaskDetails(
          titleController.text,
          descriptionController.text,
        );
        String? result =
            await taskController.updateTask(widget.task!, widget.task!.status);
        if (result == null) {
          Get.back(); // Close the modal
          showToast('Task updated successfully');
        } else {
          showToast(result);
        }
      }
    } else {
      showToast('Title and description cannot be empty');
    }
  }
}
