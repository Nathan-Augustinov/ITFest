import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/goals/goal_details_screen.dart';
import 'package:it_fest/screens/home/_utilities.dart';
import 'package:it_fest/widgets/goal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? user;
  String _userName = '';
  String _photoURL = '';

  //TODO: urmatoarea saptamana taskuri
  @override
  initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    _fetchUserName(user?.email ?? "");
    _fetchUserProfilePicture(user?.email ?? "");
  }

//TODO: show latest goals

  @override
  Widget build(BuildContext context) {
    void uploadProfilePicture() async {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);

      String userEmail = user?.email ?? "";

      Reference ref =
          FirebaseStorage.instance.ref().child("${userEmail}_profilepic.jpg");
      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) {
        if (mounted) {
          setState(() {
            _photoURL = value;
          });
        }
      });
      FirebaseFirestore.instance
          .collection('accounts')
          .get()
          .then((value) => value.docs.forEach((element) {
                if (element.id == userEmail) {
                  var docRef = FirebaseFirestore.instance
                      .collection('accounts')
                      .doc(element.id);
                  if (element['photoURL'] != "") {
                    docRef.update({'photoURL': _photoURL});
                  }
                }
              }));
    }

    return Scaffold(
        body: Container(
      padding: AppInsets.leftRight20.copyWith(top: 50),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => uploadProfilePicture(),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: _photoURL.startsWith('http')
                    ? NetworkImage(_photoURL)
                    : AssetImage(_photoURL) as ImageProvider,
              ),
            ),
            Padding(
                padding: AppInsets.left10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName.isEmpty ? 'Loading...' : _userName,
                      style: AppTexts.font16Bold.copyWith(fontSize: 20),
                    ),
                    Padding(
                      padding: AppInsets.top10,
                      child: FutureBuilder<int>(
                          future: countTasksWithTodayDeadline(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Text(
                                  snapshot.data == 0
                                      ? 'No tasks for today'
                                      : 'You have ${snapshot.data} tasks due today',
                                  style: AppTexts.font16Normal);
                            }
                          }),
                    )
                  ],
                )),
          ],
        ),
        FutureBuilder<List<Goal>>(
            future: getUpcomingGoals(user?.email ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Container(
                    height: 170,
                    padding: AppInsets.top20,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GoalDetailsScreen(
                                              goal: snapshot.data![index],
                                            )))
                              },
                              child: GoalCard(
                                goal: snapshot.data![index],
                                insets: null,
                              ),
                            )));
              }
            }),
        const SizedBox(height: 30),
        Text(
          'Shared with friends',
          style: AppTexts.font16Bold,
        ),
        FutureBuilder<List<Goal>>(
            future: getGoalsSharedForUser(user?.email ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GoalDetailsScreen(
                                            goal: snapshot.data![index],
                                            hasFriends: true,
                                          )))
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GoalCard(
                                  goal: snapshot.data![index],
                                  insets: const EdgeInsets.all(0)),
                            ),
                          )),
                );
              }
            }),
      ]),
    ));
  }

  Future<String> getUserFirstAndLastName(String email) async {
    String firstName = "";
    String lastName = "";
    await FirebaseFirestore.instance
        .collection('accounts')
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element.id == email) {
                firstName = element['firstName'];
                lastName = element['lastName'];
              }
            }));

    return "$firstName $lastName";
  }

  Future<void> _fetchUserName(email) async {
    String userName = await getUserFirstAndLastName(email);
    setState(() {
      _userName = userName;
    });
  }

  void _fetchUserProfilePicture(String email) async {
    String fileName = "${email}_profilepic.jpg";

    try {
      String url =
          await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
      setState(() {
        _photoURL = url;
      });
    } catch (e) {
      if (user?.photoURL != null) {
        setState(() {
          _photoURL = user!.photoURL!;
        });
      } else {
        setState(() {
          _photoURL = 'assets/images/empty_profile_pic.jpg';
        });
      }
    }
  }

  Future<List<Goal>> getUpcomingGoals(String userEmail) async {
    List<Goal> upcomingGoals = [];
    List<Goal> allUserGoals = await getGoalsForUser(userEmail);

    for (Goal goal in allUserGoals) {
      DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
          int.parse(goal.deadlineTimestamp));
      if (deadline.isAfter(DateTime.now()) &&
          deadline.isBefore(DateTime.now().add(const Duration(days: 7)))) {
        upcomingGoals.add(goal);
      }
    }

    return upcomingGoals;
  }

  Future<List<Goal>> getGoalsForUser(String userEmail) async {
    List<Goal> userGoals = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('goals')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot doc in querySnapshot.docs) {
          String goalId = doc.id;
          String name = doc['title'];
          String description = doc['description'];
          String userEmail = doc['userEmail'];
          String createdTimestamp = doc['createdTime'];
          String deadlineTimestamp = doc['deadline'];
          String type = doc['type'];
          String priority = doc['priority'];

          Goal goal = Goal(
              goalId: goalId,
              name: name,
              description: description,
              userEmail: userEmail,
              createdTimestamp: createdTimestamp,
              deadlineTimestamp: deadlineTimestamp,
              goalType: getType(type),
              goalPriority: getPriority(priority));
          userGoals.add(goal);
        }
      }
    } catch (e) {
      print('Error getting goals: $e');
      // Return an empty list or handle the error as per your application's requirement.
    }

    return userGoals;
  }

  Future<List<Goal>> getGoalsSharedForUser(String userEmail) async {
    List<Goal> userSharedGoals = [];
    QuerySnapshot goalsQuery =
        await FirebaseFirestore.instance.collection('goals').get();

    String goalId = '';
    for (int i = 0; i < goalsQuery.docs.length; i++) {
      goalId = goalsQuery.docs[i].id;
      await FirebaseFirestore.instance
          .collection('goals')
          .doc(goalId)
          .collection('users')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) async {
          if (doc['email'] == userEmail) {
            DocumentSnapshot goalDoc = await FirebaseFirestore.instance
                .collection('goals')
                .doc(goalId)
                .get();
            userSharedGoals.add(Goal(
                goalId: goalId,
                name: goalDoc['title'],
                description: goalDoc['description'],
                userEmail: goalDoc['userEmail'],
                createdTimestamp: goalDoc['createdTime'],
                deadlineTimestamp: goalDoc['deadline'],
                goalType: getType(goalDoc['type']),
                goalPriority: getPriority(goalDoc['priority'])));
          }
        });
      });
    }
    return userSharedGoals;
  }

  Future<int> countTasksWithTodayDeadline() async {
    int count = 0;
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    List<Goal> userGoals = await getGoalsForUser(userEmail);
    List<Goal> userSharedGoals = await getGoalsSharedForUser(userEmail);
    List<Goal> allGoals = [...userGoals, ...userSharedGoals];
    var uniqueGoals = <String, Goal>{};
    for (var goal in allGoals) {
      uniqueGoals[goal.goalId] = goal;
    }

    for (Goal goal in uniqueGoals.values) {
      if (getRemainedNumberOfDays(goal.deadlineTimestamp) == "0") {
        count++;
      }
    }
    return count;
  }
}
