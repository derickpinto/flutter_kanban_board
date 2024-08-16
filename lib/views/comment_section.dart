import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board/service_injection.dart';
import '../controllers/comment_controller.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class CommentSection extends StatelessWidget {
  final Task task;
  final bool? isComplete;
  final TextEditingController _commentController = TextEditingController();

  CommentSection({super.key, required this.task, this.isComplete});

  String formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: GetX<CommentController>(
        init: CommentController(getIt<TodoistApiService>(), task),
        tag: "comment_controller_tag_${task.id}",
        builder: (commentController) {
          return Column(
            children: [
              Expanded(
                child: commentController.comments.isEmpty
                    ? const Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: commentController.comments.length,
                        itemBuilder: (context, index) {
                          final comment = commentController.comments[index];
                          final formattedTime =
                              formatDateTime(comment.postedAt);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.content,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Posted at: $formattedTime',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              if (isComplete != true)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          commentController.addComment(_commentController.text);
                          _commentController.clear();
                        } else {
                          Get.snackbar(
                            'Error',
                            'Comment cannot be empty',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
