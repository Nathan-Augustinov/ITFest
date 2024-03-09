import 'package:flutter/material.dart';
import 'package:it_fest/widgets/task_card.dart';

class AllTasksScreen extends StatelessWidget {
  
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual list of tasks
    List<Task> tasks = [
      Task(title: 'Task 1', description: 'Description 1'),
      Task(title: 'Task 2', description: 'Description 2'),
      Task(title: 'Task 3', description: 'Description 3'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      // body: Expanded(
      //     child: ListView.builder(
      //         scrollDirection: Axis.vertical,
      //         itemCount: _tasks.length,
      //         itemBuilder: (context, index) => Padding(
      //               padding: const EdgeInsets.only(bottom: 10),
      //               child: TaskCard(
      //                 goal: _tasks[index],
      //               ),
      //             )),
      //   ),
    );
  }
}

class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});
}
