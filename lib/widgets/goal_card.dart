import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/home/_utilities.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({required this.goal, required this.insets, super.key});

  final Goal goal;
  final EdgeInsets? insets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: insets ?? AppInsets.right10,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          color: getColorByType(goal.goalType),
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
                    child: Text(
                      goal.name,
                      // style: AppTexts.font16Bold,
                    )),
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
                      getRemainedNumberOfDays(goal.deadlineTimestamp),
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
                        color: getColorByPriority(goal.goalPriority),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: AppColors.background)),
                    child: Center(child: Text(goal.goalPriority.name))),
              )
            ])
          ],
        ),
      ),
    );
  }
}