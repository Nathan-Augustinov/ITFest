import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/screens/friends/add_friends.dart';
import 'package:it_fest/screens/home/home_screen.dart';
import 'package:it_fest/screens/profile/profile.dart';
import 'package:it_fest/screens/goals/add_goal.dart';
import 'package:it_fest/screens/goals/all_goals.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentTabIndex = 0;
  double iconSize = 24;
  Account? account;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrentUserAccount();
  }

  void fetchCurrentUserAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(currentUser.email)
        .get();
    setState(() {
      account = Account(
        uid: currentUser.uid,
        firstName: currentUserDoc.data()?['firstName'],
        lastName: currentUserDoc.data()?['lastName'],
        email: currentUserDoc.data()?['email'],
        photoURL: currentUserDoc.data()?['photoURL'],
      );
    });
  }

  final List screens = [
    const HomeScreen(),
    const AddGoalScreen(),
    const ProfileScreen(
      account: null,
    )
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddGoalScreen()));
        },
        hoverElevation: 2,
        backgroundColor: AppColors.floatingNavBar,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 1,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 55,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = const HomeScreen();
                            currentTabIndex = 0;
                          });
                        },
                        child: const Icon(
                          Icons.home_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = const AllGoalsScreen();
                            currentTabIndex = 2;
                          });
                        },
                        child: const Icon(
                          Icons.task_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = AddFriendsPage();
                            currentTabIndex = 3;
                          });
                        },
                        child: const Icon(
                          Icons.people_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = ProfileScreen(
                              account: account,
                            );
                            currentTabIndex = 4;
                          });
                        },
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
