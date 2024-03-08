import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/models/task.dart';
import 'package:it_fest/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(
        taskId: "0",
        userId: "0",
        name: "Task1",
        description: "task task 1",
        taskType: TaskType.daily,
        taskPriority: TaskPriority.low,
        deadline: "1710198631000", //11.03.2024
        creationDate: "1709334631000"), //01.03.2024
    Task(
        taskId: "0",
        userId: "0",
        name: "Task1",
        description: "task task 1",
        taskType: TaskType.monthly,
        taskPriority: TaskPriority.medium,
        deadline: "1710198631000", //11.03.2024
        creationDate: "1709334631000"), //01.03.2024
    Task(
        taskId: "0",
        userId: "0",
        name: "Task1",
        description: "task task 1",
        taskType: TaskType.halfYear,
        taskPriority: TaskPriority.high,
        deadline: "1710198631000", //11.03.2024
        creationDate: "1709334631000") //01.03.2024
  ];
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //TODO: customize appBar
        appBar: AppBar(
            // title: const Text("User name"),
            ),
        body: Container(
          padding: AppInsets.leftRight20,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage:
                      //TODO: if user has image ( NetworkImage('https://picsum.photos/id/237/200/300'),) put image else
                      AssetImage('assets/images/empty_profile_pic.jpg'),
                ),
                //TODO: remove hardcoded code
                Padding(
                    padding: AppInsets.left10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User name",
                          style: AppTexts.font16Bold,
                        ),
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
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => TaskCard(
                          task: tasks[index],
                        )))
          ]),
        ));
  }
}
