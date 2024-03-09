//TODO: rename?
class Goal {
  final String goalId;
  final String userId; //userEmail
  String name;
  String description;
  TaskType goalType;
  TaskPriority goalPriority;
  String deadlineTimestamp; //timestamp
  String createdTimestamp; //timestamp

  Goal({
    required this.goalId,
    required this.userId,
    required this.name,
    required this.description,
    required this.goalType,
    required this.goalPriority,
    required this.deadlineTimestamp,
    required this.createdTimestamp,
  });
}

enum TaskType { daily, monthly, halfYear }

enum TaskPriority { low, medium, high }

enum Status { pending, completed }
