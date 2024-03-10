import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:it_fest/models/goal.dart';

const List<String> typeItems = ["Daily", "Weekly", "A month", "Half a year"];
const List<String> priorityItems = ["Low", "High", "Medium"];

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

  goalDocument.update({'goalId': goalDocument.id});
  CollectionReference usersCollection = goalDocument.collection('users');

  await usersCollection.add({
    'email': userEmail,
    'owner': true,
    'completed': false,
    'completedTimestamp': ''
  });

  checkedFriends.forEach((element) async {
    await usersCollection.add({
      'email': element,
      'owner': checkIfOwmer(userEmail, element),
      'completed': false,
      'completedTimestamp': ''
    });
  });
}

void editPersonalGoal(Goal goal, String userEmail, bool isChecked) async {
  CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');
  DocumentReference goalDocument = goalsCollection.doc(goal.goalId);

  await goalsCollection.doc(goal.goalId).update({
    'title': goal.name,
    'description': goal.description,
    'priority': goal.goalPriority.name,
    'type': goal.goalType.name,
    'deadline': returnDeadlineTimestamp(goal.goalType),
    'createdTime': getCreatedTimeMillisecondsTimestamp(),
  });

  CollectionReference usersCollection = goalDocument.collection('accounts');
  QuerySnapshot querySnapshot = await usersCollection.get();
  querySnapshot.docs.forEach((doc) {
    if (doc['email'] == userEmail) {
      DocumentReference docReference = usersCollection.doc(doc.id);
      docReference.update({
        'email': userEmail,
        'completed': isChecked,
        'completedTimestamp': getCompletedTimestamp(isChecked)
      });
    }
  });
}

String getCompletedTimestamp(bool isChecked) {
  return isChecked ? DateTime.now().millisecondsSinceEpoch.toString() : '';
}

bool checkIfOwmer(String ownerEmail, String email) {
  return ownerEmail == email;
}

String returnDeadlineTimestamp(GoalType type) {
  switch (type) {
    case GoalType.daily:
      return getDeadlineMillisecondsTimestamp(1);
    case GoalType.weekly:
      return getDeadlineMillisecondsTimestamp(7);
    case GoalType.monthly:
      return getDeadlineMillisecondsTimestamp(30);
    case GoalType.halfYear:
      return getDeadlineMillisecondsTimestamp(181);
  }
}

DateTime getDateTimeFromTimestamp(String timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  return dateTime;
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

Goal initializeGoal() {
  return Goal(
      name: "",
      description: "",
      deadlineTimestamp: "",
      createdTimestamp: "",
      goalId: "",
      userEmail: "",
      goalPriority: GoalPriority.low,
      goalType: GoalType.daily);
}

Goal initGoalWithOldOne(Goal goal) {
  return Goal(
      name: goal.name,
      description: goal.description,
      deadlineTimestamp: goal.deadlineTimestamp,
      createdTimestamp: goal.createdTimestamp,
      goalId: goal.goalId,
      userEmail: goal.userEmail,
      goalPriority: goal.goalPriority,
      goalType: goal.goalType);
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

String getTaskDropdownText(GoalType type) {
  switch (type) {
    case GoalType.daily:
      return "Daily";
    case GoalType.weekly:
      return "Weekly";
    case GoalType.monthly:
      return "A month";
    case GoalType.halfYear:
      return "Half a year";
    default:
      return "Daily";
  }
}

String getPriorityDropdownText(GoalPriority priority) {
  switch (priority) {
    case GoalPriority.low:
      return "Low";
    case GoalPriority.high:
      return "High";
    case GoalPriority.medium:
      return "Medium";
    default:
      return "Low";
  }
}
