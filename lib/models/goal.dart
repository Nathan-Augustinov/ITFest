//TODO: rename?
class Goal {
  final String goalId;
  final String userEmail; //userEmail
  String name;
  String description;
  GoalType goalType;
  GoalPriority goalPriority;
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

enum GoalType { daily, weekly, monthly, halfYear }

enum GoalPriority { low, medium, high }

enum Status { pending, completed }
