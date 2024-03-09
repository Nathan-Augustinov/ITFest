import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/goal.dart';

String getRemainedNumberOfDays(String deadlineTimestamp) {
  DateTime now = DateTime.now();
  DateTime futureDate =
      DateTime.fromMillisecondsSinceEpoch(int.parse(deadlineTimestamp));
  int difference = futureDate.difference(now).inDays;
  return difference.toString();
}

TaskPriority getPriority(String priority) {
  switch (priority) {
    case "low":
      return TaskPriority.low;
    case "medium":
      return TaskPriority.medium;
    case "high":
      return TaskPriority.high;
    default:
      return TaskPriority.low;
  }
}

TaskType getType(String type) {
  switch (type) {
    case "daily":
      return TaskType.daily;
    case "monthly":
      return TaskType.monthly;
    case "halfYear":
      return TaskType.halfYear;
    default:
      return TaskType.daily;
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
