import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/goal.dart';

class HomeUtils {
  String getRemainedNumberOfDays(String deadlineTimestamp) {
    DateTime now = DateTime.now();
    DateTime futureDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(deadlineTimestamp));
    int difference = futureDate.difference(now).inDays;
    return difference.toString();
  }

  String getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return "Low";
      case TaskPriority.medium:
        return "Medium";
      case TaskPriority.high:
        return "High";
    }
  }

  Color getColorByPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.lightGreen;
      case TaskPriority.medium:
        return AppColors.lightPurple;
      case TaskPriority.high:
        return AppColors.lightOrange;
    }
  }

  Color getColorByType(TaskType type) {
    switch (type) {
      case TaskType.daily:
        return AppColors.green;
      case TaskType.monthly:
        return AppColors.purple;
      case TaskType.halfYear:
        return AppColors.orange;
    }
  }
}
