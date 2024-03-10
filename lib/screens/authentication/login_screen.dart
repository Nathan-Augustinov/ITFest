import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/screens/authentication/register_screen.dart';
import 'package:it_fest/screens/home/bottom_nav_bar.dart';
import '../../services/google_authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  final AuthenticationService _googleAuthService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            //TODO: Change the background color to something better
            backgroundColor: AppColors.light_green,
            appBar: AppBar(
              title: const Text('Login'),
              backgroundColor: AppColors.light_green,
            ),
            body: SingleChildScrollView(
                child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusColor: AppColors.orange,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                                borderSide: const BorderSide(
                                  color: AppColors.green,
                                ),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.pink,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: _obscureText
                                  ? const Icon(Icons.visibility,
                                      color: AppColors.pink)
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: AppColors.yellow,
                                    ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: const BorderSide(
                                color: AppColors.green,
                              )),
                        ),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 18),
                              minimumSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width * 0.4),
                              foregroundColor: AppColors.green,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Login',
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
                                  loginUserWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text);
                                }
                              }
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('or'),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            minimumSize: Size.fromWidth(
                                MediaQuery.of(context).size.width * 0.4),
                            foregroundColor: AppColors.green,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          icon: Image.asset(
                            'assets/images/google_sign_in_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text('Sign in with Google'),
                          onPressed: () async {
                            User? user =
                                await _googleAuthService.signInWithGoogle();

                            if (user != null && context.mounted) {
                              FirebaseFirestore.instance
                                  .collection('accounts')
                                  .doc(user.email)
                                  .set({
                                'uid': user.uid,
                                'firstName': user.displayName!.split(' ')[0],
                                'lastName': user.displayName!.split(' ')[1],
                                'email': user.email,
                                'photoURL': user.photoURL,
                                'friends': [],
                              });

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavBar()));
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.yellow),
                            child: const Text('Forgot Password'),
                            onPressed: () {},
                          ),
                          const Text(
                            "|",
                            style: TextStyle(
                              color: AppColors.orange,
                              fontSize: 24,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.pink),
                            child: const Text('Create Account'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))));
  }

  void loginUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User logged in successfully
      User? user = userCredential.user;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('accounts')
            .doc(email)
            .update({'uid': user.uid});

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()));
      }
      // Save user email in sharedPreferences
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.lightGreen,
            content: Text('User not found for email: $email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.lightGreen,
            content:
                Text('Wrong password provided for user with email: $email')));
      }
    }
  }
}
