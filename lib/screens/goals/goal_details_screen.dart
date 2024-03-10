import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/goals/_utilities.dart';
import 'package:it_fest/widgets/custom_text_field.dart';

enum Target { daily, monthly, halfYear }

class GoalDetailsScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _typeSelectedValue;
  String? _prioritySelectedValue;
  bool _isChecked = false;
  String _userEmail = "";
  Goal _newGoal = initializeGoal();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.name);
    _descriptionController =
        TextEditingController(text: widget.goal.description);
    setState(() {
      _newGoal = initGoalWithOldOne(widget.goal);
    });
    _typeSelectedValue = getTaskDropdownText(widget.goal.goalType);
    _prioritySelectedValue = getPriorityDropdownText(widget.goal.goalPriority);
    _userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Goal Details'),
        backgroundColor: AppColors.lightOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DatePicker(
              activeDates: [DateTime.now()],
              height: 100,
              getDateTimeFromTimestamp(widget.goal.createdTimestamp),
              initialSelectedDate:
                  getDateTimeFromTimestamp(widget.goal.createdTimestamp),
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            CustomTextfield(
                label: "Change title",
                text: widget.goal.name,
                onChanged: (text) => {
                      setState(() {
                        _newGoal.name = text;
                      })
                    },
                textInputType: TextInputType.text),
            const SizedBox(height: 16.0),
            CustomTextfield(
                label: "Change description",
                text: widget.goal.description,
                onChanged: (text) => {
                      setState(() {
                        _newGoal.description = text;
                      })
                    },
                textInputType: TextInputType.text),
            const SizedBox(height: 16.0),
            Row(children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isChecked = newValue!;
                    });
                  },
                ),
              ),
              const Text("Mark as completed")
            ]),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            "Select task type",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: typeItems
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: _typeSelectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              _typeSelectedValue = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 100,
                            width: 150,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          )),
                    )),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            "Select task priority",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: priorityItems
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: _prioritySelectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              _prioritySelectedValue = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 100,
                            width: 150,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          )),
                    )),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextButton(
                      child: const Text(
                        "Save changes",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        editPersonalGoal(_newGoal, _userEmail, _isChecked);
                      }),
                ))
          ],
        ),
      ),
    );
  }
}
