import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:it_fest/models/goal.dart';

void addPersonalGoalToForebase(Goal goal, String userEmail) {
  FirebaseFirestore.instance.collection('goals').doc().set({
    'title': goal.name,
    'description': goal.description,
    'priority': goal.taskPriority.toString(),
    'type': goal.taskType.toString(),
    'userEmail': userEmail,
    'friends': [],
  });
}
