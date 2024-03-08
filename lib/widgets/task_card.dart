import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/task.dart';
import 'package:it_fest/screens/home/_utilities.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, super.key});

  final Task task;

  //TODO: change hardcoded texts
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.right10,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          //TODO: color accordingly to task
          color: HomeUtils().getColorByType(task.taskType),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: AppInsets.leftRightTopBottom10,
                    child: Text(task.name)),
                //TODO: set priority name accordingly
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: AppInsets.left10,
                child: Row(
                  children: [
                    const Icon(Icons.alarm),
                    //TODO: days until complete
                    Text(HomeUtils().getRemainedNumberOfDays(task.deadline)),
                  ],
                ),
              ),
              Padding(
                padding: AppInsets.leftRightTopBottom10,
                child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        //TODO: change color according to priority
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Text(
                            HomeUtils().getPriorityText(task.taskPriority)))),
              )
            ])
          ],
        ),
      ),
    );
  }
}
