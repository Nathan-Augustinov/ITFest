import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/screens/authentication/login_screen.dart';
import 'package:it_fest/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
              backgroundColor: AppColors.light_green,
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
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
                        obscureText: _passwordObscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _passwordObscureText = !_passwordObscureText;
                                });
                              },
                              child: _passwordObscureText
                                  ? const Icon(Icons.visibility,
                                      color: AppColors.pink)
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: AppColors.yellow,
                                    ),
                            ),
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
                        obscureText: _confirmPasswordObscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _confirmPasswordObscureText =
                                      !_confirmPasswordObscureText;
                                });
                              },
                              child: _confirmPasswordObscureText
                                  ? const Icon(Icons.visibility,
                                      color: AppColors.pink)
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: AppColors.yellow,
                                    ),
                            ),
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
                              minimumSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width * 0.4),
                              foregroundColor: AppColors.orange,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            onPressed: () {
                              bool emailIsValid = EmailValidator.validate(
                                  _emailController.text);
                              if (_formKey.currentState!.validate()) {
                                if (emailIsValid == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please enter a valid email'),
                                    ),
                                  );
                                } else {
                                  addUserToDatabase(
                                      _nameController.text,
                                      _surnameController.text,
                                      _emailController.text);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                }
                              }
                            },
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

    FirebaseFirestore.instance.collection('accounts').doc(email).set({
      'uid': userCredentials.user!.uid,
      'firstName': name,
      'lastName': surname,
      'email': email,
      'photoURL': '',
      'friends': [],
      'workout_goal': 0,
      'water_goal': 0,
      'sleep_goal': 0,
    });
  }

  void saveUserToFirebaseAuth(String email, String text) {}
}
