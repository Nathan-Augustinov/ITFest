import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:it_fest/models/goal.dart';

void addPersonalGoalToForebase(Goal goal, String userEmail) {
  FirebaseFirestore.instance.collection('goals').doc().set({
    'title': goal.name,
    'description': goal.description,
    'priority': goal.goalPriority.name,
    'type': goal.goalType.name,
    'userEmail': userEmail,
    'deadline': returnDeadlineTimestamp(goal.goalType),
    'createdTime': getCreatedTimeMillisecondsTimestamp(),
    'friends': [],
  });
}

String returnDeadlineTimestamp(TaskType type) {
  switch (type) {
    case TaskType.daily:
      return getDeadlineMillisecondsTimestamp(1);
    case TaskType.monthly:
      return getDeadlineMillisecondsTimestamp(30);
    case TaskType.halfYear:
      return getDeadlineMillisecondsTimestamp(181);
  }
}

String getCreatedTimeMillisecondsTimestamp() {
  DateTime today = DateTime.now();
  int timestamp = today.millisecondsSinceEpoch;

  return timestamp.toString();
}

String getDeadlineMillisecondsTimestamp(int days) {
  DateTime today = DateTime.now();
  DateTime deadline = today.add(Duration(days: days));
  int timestamp = deadline.millisecondsSinceEpoch;

  return timestamp.toString();
}

//TODO: refactor
TaskPriority returnTaskPriority(String priority) {
  switch (priority) {
    case "Low":
      return TaskPriority.low;
    case "High":
      return TaskPriority.high;
    case "Medium":
      return TaskPriority.medium;
    default:
      return TaskPriority.low;
  }
}

TaskType returnTaskType(String type) {
  switch (type) {
    case "Daily":
      return TaskType.daily;
    case "A month":
      return TaskType.monthly;
    case "Half a year":
      return TaskType.halfYear;
    default:
      return TaskType.daily;
  }
}
