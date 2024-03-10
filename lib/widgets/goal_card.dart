import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/screens/home/_utilities.dart';

class GoalCard extends StatefulWidget {
  const GoalCard(
      {required this.goal, this.isShared, required this.insets, super.key});

  final Goal goal;
  final EdgeInsets? insets;
  final bool? isShared;

  @override
  State<GoalCard> createState() => _GoalCardScreenState();
}

class _GoalCardScreenState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.insets ?? AppInsets.right10,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          color: getColorByType(widget.goal.goalType),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: AppInsets.leftRightTopBottom10,
                    child: Text(
                      widget.goal.name,
                    )),
                FutureBuilder<List<String>>(
                    future: getSharedUsersProfilePicturesForGoal(
                        widget.goal.goalId),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text(
                            'Error getting friends profile pictures');
                      }
                      if (widget.isShared == true) {
                        return Padding(
                            padding: AppInsets.right10,
                            child: Row(
                              children: snapshot.data
                                      ?.map((profilePicture) => CircleAvatar(
                                            radius: 15,
                                            backgroundImage: profilePicture
                                                    .startsWith('http')
                                                ? NetworkImage(profilePicture)
                                                : AssetImage(profilePicture)
                                                    as ImageProvider,
                                          ))
                                      .toList() ??
                                  [],
                            ));
                      }
                      return Container();
                    })
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: AppInsets.left10,
                child: Row(
                  children: [
                    const Icon(
                      Icons.alarm,
                      color: Colors.white,
                    ),
                    Text(
                      getRemainedNumberOfDays(widget.goal.deadlineTimestamp),
                      style: AppTexts.font16Bold.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppInsets.leftRightTopBottom10,
                child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: getColorByPriority(widget.goal.goalPriority),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: AppColors.background)),
                    child: Center(child: Text(widget.goal.goalPriority.name))),
              )
            ])
          ],
        ),
      ),
    );
  }

  Future<List<String>> getSharedUsersProfilePicturesForGoal(
      String goalId) async {
    List<String> profilePictures = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('goals')
        .doc(goalId)
        .collection('users')
        .get();
    for (DocumentSnapshot doc in querySnapshot.docs) {
      String profilePictureUrl = "";
      print(doc['email']);
      String fileName = "${doc['email']}_profilepic.jpg";
      try {
        profilePictureUrl = await FirebaseStorage.instance
            .ref()
            .child(fileName)
            .getDownloadURL();
      } catch (e) {
        profilePictureUrl = 'assets/images/empty_profile_pic.jpg';
      }

      profilePictures.add(profilePictureUrl);
    }
    return profilePictures;
  }
}
