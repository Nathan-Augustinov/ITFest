//TODO: rename?
class Goal {
  final String goalId;
  final String userEmail; //userEmail
  String name;
  String description;
  TaskType goalType;
  TaskPriority goalPriority;
  String deadlineTimestamp; //timestamp
  String createdTimestamp; //timestamp

  Goal({
    required this.goalId,
    required this.userEmail,
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
