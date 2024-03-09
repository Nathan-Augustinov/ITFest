import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/goals/_utilities.dart';
import 'package:it_fest/widgets/custom_checkbox_list.dart';
import 'package:it_fest/widgets/custom_text_field.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  static const List<String> _typeItems = ["Daily", "A month", "Half a year"];
  static const List<String> _priorityItems = ["Low", "High", "Medium"];
  Goal goal = Goal(
      name: "",
      description: "",
      deadlineTimestamp: "",
      createdTimestamp: "",
      goalId: "",
      userEmail: "",
      goalPriority: GoalPriority.low,
      goalType: GoalType.daily);
  String userEmail = "";
  List<String> _friendsEmails = [];
  List<Account> _friends = [];

  @override
  initState() {
    super.initState();
    setState(() {
      userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    });
  }

  Future<List<Account>> getFriendAccounts() async {
    List<Account> friendAccounts = [];

    final currentUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(userEmail)
        .get();
    final friendsArray = currentUserDoc.data()?['friends'] as List<dynamic>;

    if (friendsArray.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .where('email', whereIn: friendsArray.cast<String>())
          .get();

      friendAccounts = querySnapshot.docs.map((doc) {
        return Account(
          uid: doc['uid'],
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          email: doc['email'],
          photoURL: doc['photoURL'],
        );
      }).toList();
    }

    return friendAccounts;
  }

  List<bool> _checkBoxes = [];
  String? _typeSelectedValue;
  String? _prioritySelectedValue;

  Future<void> showCheckBoxDialog(BuildContext context) async {
    List<Account> friendList = await getFriendAccounts();

    setState(() {
      if (_checkBoxes.isEmpty) {
        _checkBoxes = List<bool>.filled(friendList.length, false);
      }
      _friends = friendList;
    });

    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return CheckboxDialog(
              friendList: friendList,
              checkboxStates: _checkBoxes,
            );
          });
    }
  }

  void _createListOfCheckedFriends() {
    int index = 0;
    _checkBoxes.forEach((element) {
      if (element) {
        _friendsEmails.add(_friends[index].email);
      }
      index++;
    });
  }

  //TODO: clear fields after save
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add personal goal"),
          backgroundColor: AppColors.background,
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
                        onPressed: () => showCheckBoxDialog(context)),
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
                          "Create",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          String userEmail =
                              FirebaseAuth.instance.currentUser?.email ?? "";
                          if (userEmail.isNotEmpty) {
                            setState(() {
                              //TODO: validation!!
                              goal.goalPriority = returnGoalPriority(
                                  _prioritySelectedValue ?? "");
                              goal.goalType =
                                  returnTaskType(_typeSelectedValue ?? "");
                            });
                            _createListOfCheckedFriends();
                            addPersonalGoalToForebase(
                                goal, userEmail, _friendsEmails);
                          }
                        }),
                  ),
                ),
              ],
            )));
  }
}
