import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.posiviteActionText,
    required this.positiveAction,
    this.negativeActionText,
    this.negativeAction,
  }) : super(key: key);
  final String title;
  final String description;
  final String? negativeActionText;
  final String posiviteActionText;
  void Function()? negativeAction;
  void Function() positiveAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      backgroundColor: AppColors.background,
      title: Column(children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.green,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.lightGreen)))),
      ]),
      content: Text(
        description,
        textAlign: TextAlign.center,
      ),
      actions: [
        Visibility(
          visible: negativeActionText != null,
          child: TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.green),
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                negativeActionText ?? "",
                style: const TextStyle(color: AppColors.green),
              )),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            positiveAction();
          },
          child: Container(
            width: 60,
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Text(
              posiviteActionText,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
