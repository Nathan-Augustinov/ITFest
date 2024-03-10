import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/goal.dart';
import 'package:it_fest/models/goal_friend.dart';
import 'package:it_fest/screens/goals/_utilities.dart';

class SharedGoalFriendsCard extends StatefulWidget {
  const SharedGoalFriendsCard({required this.goal, super.key});

  final Goal goal;

  @override
  State<SharedGoalFriendsCard> createState() => _SharedGoalFriendsCardState();
}

class _SharedGoalFriendsCardState extends State<SharedGoalFriendsCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GoalFriend>>(
        future: getSharedGoalFriendList(widget.goal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) => Container(
                        height: 170,
                        padding: AppInsets.top20.copyWith(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.friendCardOrange,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: AppInsets.leftRightTopBottom10,
                                  child: Text(
                                    snapshot.data![index].email,
                                    style: AppTexts.font16Bold,
                                  )),
                              Padding(
                                padding: AppInsets.leftRightTopBottom10,
                                child: Center(
                                    child: Icon(
                                  Icons.circle_rounded,
                                  color: snapshot.data![index].completed
                                      ? AppColors.green
                                      : AppColors.orange,
                                )),
                              )
                            ],
                          ),
                        ))),
              ),
            );
          }
        });
  }
}
