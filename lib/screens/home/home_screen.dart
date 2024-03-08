import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';
import 'package:it_fest/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage:
                      //TODO: if user has image ( NetworkImage('https://picsum.photos/id/237/200/300'),) put image else
                      AssetImage('assets/images/empty_profile_pic.png'),
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
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  //TODO: ListBuilder after data fetch
                  children: List.generate(10, (int index) {
                    //TODO: send data
                    return TaskCard();
                  })),
            ),
          ]),
        ));
  }
}
