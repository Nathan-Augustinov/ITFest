import 'package:flutter/material.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/widgets/task_card.dart';

class AllGoalsScreen extends StatelessWidget {
  const AllGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual list of tasks
    List<Goal> _tasks = [
      // Goal(name: 'Task 1', description: 'Description 1', ),
      // Goal(name: 'Task 2', description: 'Description 2'),
      // Goal(name: 'Task 3', description: 'Description 3'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      body: Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _tasks.length,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GoalCard(
                    goal: _tasks[index],
                  ),
                )),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});
}
