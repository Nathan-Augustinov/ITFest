import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/task/_utilities.dart';
import 'package:it_fest/widgets/custom_checkbox_list.dart';
import 'package:it_fest/widgets/custom_text_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static const List<String> _typeItems = ["Daily", "A month", "Half a year"];
  static const List<String> _priorityItems = ["Low", "High", "Medium"];
  Goal goal = Goal(
    name: "",
    description: "",
    deadlineTimestamp: "",
    createdTimestamp: "",
    goalId: "",
    userId: "",
    goalPriority: TaskPriority.low,
    goalType: TaskType.daily,
  );
  //TODO: list should be fetched from db
  final List<Account> _friendList = [
    Account(
      uid: "id",
      firstName: "firstName",
      lastName: "lastname",
      email: "email",
      photoURL: "",
      friendsIds: ["email", "email"],
    ),
    Account(
      uid: "id",
      firstName: "firstName 1",
      lastName: "lastname 1",
      email: "email",
      photoURL: "",
      friendsIds: ["email", "email"],
    ),
    Account(
      uid: "id",
      firstName: "firstName 2",
      lastName: "lastname 2",
      email: "email",
      photoURL: "",
      friendsIds: ["email", "email"],
    ),
    Account(
      uid: "id",
      firstName: "firstName 3",
      lastName: "lastname 3",
      email: "email",
      photoURL: "",
      friendsIds: ["email", "email"],
    )
  ];

  @override
  initState() {
    super.initState();
  }

  //TODO: should be initialize with the account list
  List<bool> _checkBoxes = [false, false, false, false];
  String? _typeSelectedValue;
  String? _prioritySelectedValue;

  showCheckBoxDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CheckboxDialog(
            friendList: _friendList,
            checkboxStates: _checkBoxes,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add task"),
        ),
        //TODO: add legend
        body: Container(
            color: AppColors.background,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 25),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 24),
                CustomTextfield(
                  label: "Title",
                  text: "",
                  textInputType: TextInputType.name,
                  onChanged: (name) {
                    setState(() {
                      goal.name = name;
                    });
                  },
                ),
                const SizedBox(height: 24),
                CustomTextfield(
                  label: "Description",
                  text: "",
                  textInputType: TextInputType.name,
                  onChanged: (description) {
                    setState(() {
                      goal.description = description;
                    });
                  },
                ),
                //TODO: refctor in widget
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
                          items: _typeItems
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
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          )),
                    )),

                const SizedBox(height: 24),
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
                          items: _priorityItems
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
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          )),
                    )),

                const SizedBox(height: 24),
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
                          "Reach goals with your friends!",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => showCheckBoxDialog()),
                  ),
                ),
                const SizedBox(
                  height: 24,
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
                          "Add personal goal",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          String userEmail =
                              FirebaseAuth.instance.currentUser?.email ?? "";
                          if (userEmail.isNotEmpty) {
                            setState(() {
                              //TODO: validation!!
                              goal.goalPriority = returnTaskPriority(
                                  _prioritySelectedValue ?? "");
                              goal.goalType =
                                  returnTaskType(_typeSelectedValue ?? "");
                            });
                            addPersonalGoalToForebase(goal, userEmail);
                          }
                        }),
                  ),
                ),
              ],
            )));
  }
}
