import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/screens/authentication/login_screen.dart';
import 'package:it_fest/widgets/custom_dialog.dart';
import 'package:it_fest/widgets/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String _emailBody = "";
  String _emailSubject = "";

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
                _navigateToLogin();
              });
        });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  void _sendEmailToAdmin(String emailBody, String emailSubject) async {
    String email = Uri.encodeFull("alis.haiduc7773@gmail.com");
    String subject = Uri.encodeFull(emailSubject);
    String body = Uri.encodeFull(emailBody);
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");

    if (await canLaunchUrl(mail)) {
      await launchUrl(mail);
    } else {
      throw 'Could not launch $mail';
    }
  }

  showSendEmailDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            backgroundColor: AppColors.background,
            title: Column(children: [
              const Text(
                "What do you want to tell us",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              CustomTextfield(
                maxLines: 3,
                text: _emailBody,
                hint: "Subject",
                textInputType: TextInputType.text,
                onChanged: (subject) {
                  setState(() {
                    _emailSubject = subject;
                  });
                },
              ),
              CustomTextfield(
                maxLines: 20,
                text: _emailBody,
                hint: "Body",
                textInputType: TextInputType.text,
                onChanged: (body) {
                  setState(() {
                    _emailBody = body;
                  });
                },
              ),
            ]),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.normal),
                  )),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                onPressed: () async {
                  _sendEmailToAdmin(_emailBody, _emailSubject);
                },
                child: Container(
                  width: 60,
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: AppColors.lightOrange,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(color: AppColors.background),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.navBar,
      appBar: AppBar(
        backgroundColor: AppColors.lightGreen,
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
                  onPressed: () async {
                    //TODO: update firebase
                  if (_firstname.isEmpty || _lastname.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("First name and last name can't be empty"),
                      ),
                    );
                    return;
                  }
                  
                  // Attempt to update user details in Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('accounts')
                        .doc(widget.account?.email) // Assuming email is used as the document ID
                        .update({
                          'firstName': _firstname,
                          'lastName': _lastname,
                          // Include any other fields you might have
                        });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error updating profile: $e"),
                      ),
                    );
                  }
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => showSendEmailDialog(),
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
