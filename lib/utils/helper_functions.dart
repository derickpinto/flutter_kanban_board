import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_string.dart';

void showToast(String errorMessage) {
  Get.snackbar(
    '',
    errorMessage,
    snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
    backgroundColor: Colors.black, // Background color
    colorText: Colors.white, // Text color
    duration: const Duration(seconds: 2), // Duration of the Snackbar
    borderRadius: 8, // Border radius of the Snackbar
    margin: const EdgeInsets.all(16), // Margin around the Snackbar
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside the Snackbar
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
      ),
    ],
  );
}


String getStatus(String statusId, {bool getId = false}) {
  final statusKeys = {
    "163815572": AppString.todoState,
    "163815746": AppString.inProgressState,
    "163815755": AppString.doneState,
  };

  if (getId) {
    return statusKeys.entries
        .firstWhere(
          (entry) => entry.value == statusId,
      orElse: () => const MapEntry('', ''),
    )
        .key;
  }

  return statusKeys[statusId] ?? '';
}