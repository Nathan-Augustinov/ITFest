import 'package:flutter/material.dart';
import 'package:it_fest/models/account.dart';

class CheckboxDialog extends StatefulWidget {
  CheckboxDialog(
      {required this.friendList, required this.checkboxStates, super.key});

  final List<Account> friendList;
  List<bool> checkboxStates;

  @override
  State<CheckboxDialog> createState() => _CheckboxDialogState();
}

class _CheckboxDialogState extends State<CheckboxDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Choose from your friends',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 200,
        width: 200,
        child: ListView(
          children: [
            for (int i = 0; i < widget.friendList.length; i++)
              CheckboxListTile(
                title: Text(widget.friendList[i].firstName +
                    widget.friendList[i].lastName),
                value: widget.checkboxStates[i],
                onChanged: (newValue) {
                  setState(() {
                    widget.checkboxStates[i] = newValue ?? false;
                  });
                },
              )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
