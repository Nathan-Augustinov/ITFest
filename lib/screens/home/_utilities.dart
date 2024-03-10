import 'package:cloud_firestore/cloud_firestore.dart';
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

void deleteTask(Goal goal) async {
  await FirebaseFirestore.instance
      .collection('goals')
      .doc(goal.goalId)
      .delete();
}

GoalPriority getPriority(String priority) {
  switch (priority) {
    case "low":
      return GoalPriority.low;
    case "medium":
      return GoalPriority.medium;
    case "high":
      return GoalPriority.high;
    default:
      return GoalPriority.low;
  }
}

GoalType getType(String type) {
  switch (type) {
    case "daily":
      return GoalType.daily;
    case "monthly":
      return GoalType.monthly;
    case "halfYear":
      return GoalType.halfYear;
    default:
      return GoalType.daily;
  }
}

Color getColorByPriority(GoalPriority priority) {
  switch (priority) {
    case GoalPriority.low:
      return AppColors.lightGreen;
    case GoalPriority.medium:
      return AppColors.lightPurple;
    case GoalPriority.high:
      return AppColors.lightOrange;
  }
}

Color getColorByType(GoalType type) {
  switch (type) {
    case GoalType.daily:
      return AppColors.green;
    case GoalType.weekly:
      return AppColors.blue;
    case GoalType.monthly:
      return AppColors.purple;
    case GoalType.halfYear:
      return AppColors.orange;
  }
}
