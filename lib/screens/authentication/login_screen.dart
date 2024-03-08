import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/screens/authentication/register_screen.dart';
import 'package:it_fest/screens/start_page.dart';
import '../../services/google_authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthenticationService _googleAuthService = AuthenticationService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement login functionality
                    if (_formKey.currentState!.validate()) {
                      loginUserWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => StartPage()));
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'If you are not registered, click here',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement register functionality
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Or sign in with Google',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Implement sign in with Google functionality
                    User? user = await _googleAuthService.signInWithGoogle();

                    if (user != null && context.mounted) {
                      // Navigate to Home Screen

                      // Add account to Firestore
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

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => StartPage()));
                    }
                  },
                  child: const Text('Sign in with Google'),
                ),
              ],
            ),
          ),
        ));
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
      FirebaseFirestore.instance
          .collection('accounts')
          .doc(email)
          .update({'uid': user!.uid});
      print('User logged in: ${user.email}');
    } catch (e) {
      // Error occurred while logging in
      print('Error logging in: $e');
    }
  }
}
