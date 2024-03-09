import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/screens/authentication/login_screen.dart';
import 'package:it_fest/constants/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // setState(() {
                          //   _firstname = value.trim();
                          // });
                        },
                        decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).first_name,
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.orange,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: AppColors.light_green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _surnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // setState(() {
                          //   _firstname = value.trim();
                          // });
                        },
                        decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).first_name,
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.orange,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: AppColors.light_green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // setState(() {
                          //   _firstname = value.trim();
                          // });
                        },
                        decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).first_name,
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.orange,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: AppColors.light_green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // setState(() {
                          //   _firstname = value.trim();
                          // });
                        },
                        decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).first_name,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.orange,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: AppColors.light_green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // setState(() {
                          //   _firstname = value.trim();
                          // });
                        },
                        decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).first_name,
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.orange,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: AppColors.light_green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 18),
                                  minimumSize: Size.fromWidth(MediaQuery.of(context).size.width * 0.4),
                                  foregroundColor: AppColors.orange,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  // AppLocalizations.of(context).login,
                                  'Register',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addUserToDatabase(_nameController.text,
                                        _surnameController.text, _emailController.text);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginScreen()),
                                    );
                                }},
                              ),

                            ),
                          ),
                    ],
                  ),
                ),
              ),
            )));
  }

  void addUserToDatabase(String name, String surname, String email) async {
    // Perform database insertion logic here

    UserCredential userCredentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: _passwordController.text,
    );

    print(userCredentials.user!.uid);

    FirebaseFirestore.instance.collection('accounts').doc(email).set({
      'uid': userCredentials.user!.uid,
      'firstName': name,
      'lastName': surname,
      'email': email,
      'photoURL': '',
      'friends': [],
    });
  }

  void saveUserToFirebaseAuth(String email, String text) {}
}
