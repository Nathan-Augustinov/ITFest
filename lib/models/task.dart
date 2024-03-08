class Task {
  final String taskId;
  final String userId;
  final String name;
  final String description;
  final TaskType taskType;
  final TaskPriority taskPriority;
  final String deadline; //timestamp
  final String creationDate; //timestamp

  Task({
    required this.taskId,
    required this.userId,
    required this.name,
    required this.description,
    required this.taskType,
    required this.taskPriority,
    required this.deadline,
    required this.creationDate,
  });
}

enum TaskType { daily, monthly, halfYear }

enum TaskPriority { low, medium, high }

enum Status { pending, completed }
