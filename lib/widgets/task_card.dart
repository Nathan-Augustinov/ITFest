import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/insets.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  //TODO: change hardcoded texts
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.right10,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          //TODO: color accordingly to task
          color: AppColors.pink,
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
                    child: const Text("Task name")),
                //TODO: set priority name accordingly
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: AppInsets.left10,
                child: const Row(
                  children: [
                    Icon(Icons.alarm),
                    //TODO: days until complete
                    Text("6"),
                  ],
                ),
              ),
              Padding(
                padding: AppInsets.leftRightTopBottom10,
                child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.black)),
                    child: const Center(child: Text("High"))),
              )
            ])
          ],
        ),
      ),
    );
  }
}
