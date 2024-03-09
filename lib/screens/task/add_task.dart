import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/task/_utilities.dart';
import 'package:it_fest/widgets/custom_checkbox_list.dart';
import 'package:it_fest/widgets/custom_dropdown_button.dart';
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
    deadline: "",
    creationDate: "",
    taskId: "",
    userId: "",
    taskPriority: TaskPriority.low,
    taskType: TaskType.daily,
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

  String? selectedValue;
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
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                CustomTextfield(
                  label: "Description",
                  text: "",
                  textInputType: TextInputType.name,
                  onChanged: (email) {
                    setState(() {});
                  },
                ),
                CustomDropdownButton(
                    items: _typeItems, hint: "Select task type"),
                const SizedBox(height: 24),
                CustomDropdownButton(
                    items: _priorityItems, hint: "Select task priority"),
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
                          "Add task",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          String userEmail =
                              FirebaseAuth.instance.currentUser?.email ?? "";
                          if (userEmail.isNotEmpty) {
                            addPersonalGoalToForebase(goal, userEmail);
                          }
                        }),
                  ),
                ),
              ],
            )));
  }
}
