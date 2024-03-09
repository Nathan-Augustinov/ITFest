import 'package:flutter/material.dart';
import 'package:it_fest/screens/authentication/login_screen.dart';
import 'package:it_fest/services/google_authentication.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Start Page!',
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

void _signOut(BuildContext context) async {
  await AuthenticationService().signOutFromGoogle();
  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
