import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_color.dart';
import '../constants/app_string.dart';

class TaskStatusMenu extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const TaskStatusMenu({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String newStatus) {
        if (newStatus != currentStatus) {
          onStatusChanged(newStatus);
        }
      },
      itemBuilder: (BuildContext context) {
        return <String>[
          AppString.todoState,
          AppString.inProgressState,
          AppString.doneState
        ].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      },
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.white,
        ),
        label: Text(
          currentStatus,
          style: GoogleFonts.inter(color: AppColors.white),
        ),
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: _getStatusColor(currentStatus),
        ),
        onPressed:
            null, // No need for an onPressed as it's handled by PopupMenuButton
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppString.todoState:
        return Colors.blue;
      case AppString.inProgressState:
        return Colors.orange;
      case AppString.doneState:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
