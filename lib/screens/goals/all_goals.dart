import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/home/_utilities.dart';
import 'package:it_fest/widgets/task_card.dart';

class AllGoalsScreen extends StatefulWidget {
  const AllGoalsScreen({super.key});

  @override
  State<AllGoalsScreen> createState() => _AllGoalsScreenState();
}

class _AllGoalsScreenState extends State<AllGoalsScreen> {
  late Future<List<Goal>> _allUserGoalsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allUserGoalsFuture = getAllGoals();
  }

  Future<List<Goal>> getGoalsForUser(String userEmail) async {
    List<Goal> userGoals = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('goals')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot doc in querySnapshot.docs) {
          String goalId = doc.id;
          String name = doc['title'];
          String description = doc['description'];
          String userEmail = doc['userEmail'];
          String createdTimestamp = doc['createdTime'];
          String deadlineTimestamp = doc['deadline'];
          String type = doc['type'];
          String priority = doc['priority'];

          Goal goal = Goal(
              goalId: goalId,
              name: name,
              description: description,
              userEmail: userEmail,
              createdTimestamp: createdTimestamp,
              deadlineTimestamp: deadlineTimestamp,
              goalType: getType(type),
              goalPriority: getPriority(priority));
          userGoals.add(goal);
        }
      }
    } catch (e) {
      print('Error getting goals: $e');
      // Return an empty list or handle the error as per your application's requirement.
    }

    return userGoals;
  }

  Future<List<Goal>> getGoalsSharedForUser(String userEmail) async {
    List<Goal> userSharedGoals = [];
    QuerySnapshot goalsQuery =
        await FirebaseFirestore.instance.collection('goals').get();

    String goalId = '';
    for (int i = 0; i < goalsQuery.docs.length; i++) {
      goalId = goalsQuery.docs[i].id;
      await FirebaseFirestore.instance
          .collection('goals')
          .doc(goalId)
          .collection('users')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) async {
          if (doc['email'] == userEmail) {
            DocumentSnapshot goalDoc = await FirebaseFirestore.instance
                .collection('goals')
                .doc(goalId)
                .get();
            userSharedGoals.add(Goal(
                goalId: goalId,
                name: goalDoc['title'],
                description: goalDoc['description'],
                userEmail: goalDoc['userEmail'],
                createdTimestamp: goalDoc['createdTime'],
                deadlineTimestamp: goalDoc['deadline'],
                goalType: getType(goalDoc['type']),
                goalPriority: getPriority(goalDoc['priority'])));
          }
        });
      });
    }
    return userSharedGoals;
  }

  Future<List<Goal>> getAllGoals() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    List<Goal> userGoals = await getGoalsForUser(userEmail);
    List<Goal> userSharedGoals = await getGoalsSharedForUser(userEmail);
    List<Goal> allGoals = [...userGoals, ...userSharedGoals];
    var uniqueGoals = <String, Goal>{};
    for (var goal in allGoals) {
      uniqueGoals[goal.goalId] = goal;
    }

    return uniqueGoals.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual list of tasks
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Goals'),
      ),
      body: FutureBuilder<List<Goal>>(
        future: _allUserGoalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final goals = snapshot.data!;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: goals.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GoalCard(
                        goal: goals[index],
                      ),
                    ));
          } else {
            return const Center(
              child: Text('No goals found'),
            );
          }
        },
      ),
    );
  }
}
