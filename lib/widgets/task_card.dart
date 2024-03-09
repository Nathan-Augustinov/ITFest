import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/home/_utilities.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.goal, super.key});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.right10,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          color: HomeUtils().getColorByType(goal.goalType),
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
                    child: Text(goal.name)),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: AppInsets.left10,
                child: Row(
                  children: [
                    const Icon(
                      Icons.alarm,
                      color: Colors.white,
                    ),
                    Text(
                      HomeUtils()
                          .getRemainedNumberOfDays(goal.deadlineTimestamp),
                      style: AppTexts.font16Bold.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppInsets.leftRightTopBottom10,
                child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color:
                            HomeUtils().getColorByPriority(goal.goalPriority),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: AppColors.background)),
                    child: Center(
                        child: Text(
                            HomeUtils().getPriorityText(goal.goalPriority)))),
              )
            ])
          ],
        ),
      ),
    );
  }
}
