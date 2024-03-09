import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:it_fest/models/goal.dart';

void addPersonalGoalToForebase(
    Goal goal, String userEmail, List<String> checkedFriends) async {
  CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');

  DocumentReference goalDocument = await goalsCollection.add({
    'title': goal.name,
    'description': goal.description,
    'priority': goal.goalPriority.name,
    'type': goal.goalType.name,
    'userEmail': userEmail,
    'deadline': returnDeadlineTimestamp(goal.goalType),
    'createdTime': getCreatedTimeMillisecondsTimestamp(),
  });

  CollectionReference usersCollection = goalDocument.collection('users');

//TODO: refactor
  await usersCollection.add({
    'email': userEmail,
    'owner': true,
    'completed': false,
  });

  checkedFriends.forEach((element) async {
    await usersCollection.add({
      'email': element,
      'owner': checkIfOwmer(userEmail, element),
      'completed': false,
    });
  });
}

bool checkIfOwmer(String ownerEmail, String email) {
  return ownerEmail == email;
}

String returnDeadlineTimestamp(GoalType type) {
  switch (type) {
    case GoalType.daily:
      return getDeadlineMillisecondsTimestamp(1);
    case GoalType.monthly:
      return getDeadlineMillisecondsTimestamp(30);
    case GoalType.halfYear:
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
GoalPriority returnGoalPriority(String priority) {
  switch (priority) {
    case "Low":
      return GoalPriority.low;
    case "High":
      return GoalPriority.high;
    case "Medium":
      return GoalPriority.medium;
    default:
      return GoalPriority.low;
  }
}

GoalType returnTaskType(String type) {
  switch (type) {
    case "Daily":
      return GoalType.daily;
    case "A month":
      return GoalType.monthly;
    case "Half a year":
      return GoalType.halfYear;
    default:
      return GoalType.daily;
  }
}
