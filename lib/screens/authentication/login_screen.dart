import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/models/account.dart';
import 'package:it_fest/screens/authentication/register_screen.dart';
import 'package:it_fest/screens/start_page.dart';
import '../../services/google_authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LoginScreen extends StatelessWidget {
  final AuthenticationService _googleAuthService = AuthenticationService();

  LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement login functionality
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
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
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
              onPressed: () async{
                // TODO: Implement sign in with Google functionality
                User? user = await _googleAuthService.signInWithGoogle();

                if (user != null && context.mounted) {
                  // Navigate to Home Screen
                  Account account = Account(
                    uid: user.uid,
                    firstName: user.displayName!.split(' ')[0],
                    lastName: user.displayName!.split(' ')[1],
                    email: user.email!,
                    photoURL: user.photoURL!
                  );

                  // Add account to Firestore
                  FirebaseFirestore.instance.collection('accounts').doc(user.uid).set({
                    'uid': account.uid,
                    'firstName': account.firstName,
                    'lastName': account.lastName,
                    'email': account.email,
                    'photoURL': account.photoURL
                  });

                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => StartPage())
                  );
                }
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
