import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class Task {
  String id;
  String title;
  String? description;
  String status;
  DateTime creationTime;
  final Map<String, Duration> timeSpentInStatus;
  List labels; // List should be of type String
  Color? color;

  Task({
    required this.id,
    required this.title,
    this.status = 'To Do',
    this.description = '',
    DateTime? creationTime,
    Map<String, Duration>? timeSpentInStatus,
    List? labels, // Default to empty list
    Color? color,
  })  : creationTime = creationTime ?? DateTime.now(),
        timeSpentInStatus = timeSpentInStatus ?? {},
        labels = labels ?? [],
        color = AppColors.getRandomColor(); // Default to empty list

  void updateStatus(String newStatus) {
    status = newStatus;
  }

  void updateId(String newId) {
    id = newId;
  }

  void updateCreatedDate(String newDate) {
    creationTime = DateTime.parse(newDate);
  }

  void updateLabels(List newLabels) {
    labels = newLabels;
  }

  bool isTimerRunning() {
    return labels.length >= 2 && labels[1] != "STOPPED";
  }

  String getTotalTimeSinceCreation() {
    final currentTime = DateTime.now();
    final duration = currentTime.difference(creationTime);

    return durationToString(duration);
  }

  // Get the current total time spent including the running time
  String getTotalTimeSpent() {
    if (labels.isEmpty) return durationToString(Duration.zero);

    if (!isTimerRunning()) return labels[0];
    Duration totalDuration = stringToDuration(labels[0]);

    if (isTimerRunning()) {
      DateTime startTime = DateTime.parse(labels[1]);
      totalDuration += DateTime.now().difference(startTime);
    }

    return durationToString(totalDuration);
  }

  // Convert String to Duration
  Duration stringToDuration(String duration) {
    List<String> parts = duration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );

  }

  String getFormattedDate() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String year = creationTime.year.toString();
    String month = twoDigits(creationTime.month);
    String day = twoDigits(creationTime.day);

    return '$day-$month-$year';
  }


  // Convert Duration to String
  String durationToString(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void updateTaskDetails(String newTitle, String newDescription) {
    title = newTitle;
    description = newDescription;
  }
}

class Comment {
  final String id;
  final String taskId;
  final String? projectId;
  final String content;
  final DateTime postedAt;
  final String? attachment;

  Comment({
    required this.id,
    required this.taskId,
    this.projectId,
    required this.content,
    required this.postedAt,
    this.attachment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      taskId: json['task_id'],
      projectId: json['project_id'],
      content: json['content'],
      postedAt: DateTime.parse(json['posted_at']),
      attachment: json['attachment'],
    );
  }
}
