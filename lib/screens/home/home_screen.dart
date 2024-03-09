import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? user;
  late Account _account;
  String _userName = '';
  final List<Goal> _tasks = [
    Goal(
        goalId: "0",
        userId: "0",
        name: "Task1",
        description: "task task 1",
        goalType: TaskType.daily,
        goalPriority: TaskPriority.low,
        deadlineTimestamp: "1710198631000", //11.03.2024
        createdTimestamp: "1709334631000"), //01.03.2024
    Goal(
        goalId: "0",
        userId: "0",
        name: "Task1",
        description: "task task 1",
        goalType: TaskType.monthly,
        goalPriority: TaskPriority.medium,
        deadlineTimestamp: "1710198631000", //11.03.2024
        createdTimestamp: "1709334631000"), //01.03.2024
    Goal(
        goalId: "0",
        userId: "0",
        name: "Task1",
        description: "task task 1",
        goalType: TaskType.halfYear,
        goalPriority: TaskPriority.high,
        deadlineTimestamp: "1710198631000", //11.03.2024
        createdTimestamp: "1709334631000") //01.03.2024
  ];

  @override
  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserName(user?.email ?? "");
  }

  void uploadProfilePicture() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);

    String userEmail = user?.email ?? "";
    print("userEmail : $userEmail");
    Reference ref =
        FirebaseStorage.instance.ref().child("${userEmail}_profilepic.jpg");
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      if (mounted) {
        setState(() {
          _account.photoURL = value;
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
                  docRef.update({'photoURL': _account.photoURL});
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //TODO: customize appBar

        body: Container(
      padding: AppInsets.leftRight20.copyWith(top: 50),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => uploadProfilePicture(),
              child: const CircleAvatar(
                radius: 35,
                backgroundImage:
                    //TODO: if user has image ( NetworkImage('https://picsum.photos/id/237/200/300'),) put image else
                    AssetImage('assets/images/empty_profile_pic.jpg'),
              ),
            ),
            //TODO: remove hardcoded code
            Padding(
                padding: AppInsets.left10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: if user has name show name else show loading
                    Text(
                      _userName.isEmpty ? 'Loading...' : _userName,
                      style: AppTexts.font16Bold,
                    ),
                    // FutureBuilder<String>(
                    //     future: getUserFirstAndLastName(user?.email ?? ""),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         return Text(
                    //           snapshot.data!,
                    //           style: AppTexts.font16Bold,
                    //         );
                    //       } else {
                    //         return Text(
                    //           "Loading...",
                    //           style: AppTexts.font16Bold,
                    //         );
                    //       }
                    //     }),
                    //TODO: if has tasks change text
                    Padding(
                      padding: AppInsets.top10,
                      child: Text(
                        "You have no tasks due today!",
                        style: AppTexts.font14Normal,
                      ),
                    )
                  ],
                )),
          ],
        ),
        Container(
            height: 170,
            padding: AppInsets.top20,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tasks.length,
                itemBuilder: (context, index) => TaskCard(
                      goal: _tasks[index],
                    )))
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
}
