import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/screens/authentication/login_screen.dart';
import 'package:it_fest/widgets/custom_dialog.dart';
import 'package:it_fest/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.account}) : super(key: key);

  final Account? account;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageURL = "";
  String _firstname = "";
  String _lastname = "";

  //TODO: save, prefill firstname, lastname for email password users if time allows

  showLogOutDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              title: "You are about to log out",
              description: "Are you sure?",
              negativeActionText: "Cancel",
              posiviteActionText: "Yes",
              positiveAction: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.navBar,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Edit profile"),
      ),
      body: Container(
        color: AppColors.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 25),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            CustomTextfield(
              label: "First name",
              text: widget.account?.firstName ?? "",
              textInputType: TextInputType.name,
              onChanged: (name) {
                setState(() {
                  _firstname = name;
                });
              },
            ),
            const SizedBox(height: 24),
            CustomTextfield(
              label: "Last name",
              text: widget.account?.lastName ?? "",
              textInputType: TextInputType.name,
              onChanged: (name) {
                setState(() {
                  _lastname = name;
                });
              },
            ),
            const SizedBox(height: 24),
            CustomTextfield(
              isEnable: false,
              label: "Email",
              text: widget.account?.email ?? "",
              textInputType: TextInputType.emailAddress,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton(
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    //TODO: update firebase
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton(
                  child: const Text(
                    "Suggest an improvement",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton(
                  child: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    showLogOutDialog();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
