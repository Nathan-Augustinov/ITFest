import 'package:flutter/cupertino.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/insets.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.right10,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          color: AppColors.pink,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Column(
          children: [Text("Task name")],
        ),
      ),
    );
  }
}
