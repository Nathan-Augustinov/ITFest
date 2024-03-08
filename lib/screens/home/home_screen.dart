import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';

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
            Expanded(
              flex: 1,
              child: Row(
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
            ),
            Expanded(
              flex: 3,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (int index) {
                    //TODO: create card widget
                    return Card(
                      color: Colors.blue[index * 100],
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Text("$index"),
                      ),
                    );
                  })),
            )
          ]),
        ));
  }
}
