import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/firebase_options.dart';
import 'package:it_fest/screens/authentication/login_screen.dart';
import 'package:it_fest/screens/home/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "LifeSync",
        theme: ThemeData(
          bottomAppBarTheme: BottomAppBarTheme(
              color: AppColors.navBar,
              surfaceTintColor: AppColors.navBar,
              shadowColor: AppColors.navBar),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return const BottomNavBar(); // User is signed in
            } else {
              return const LoginScreen(); // User is not signed in
            }
          },
        )
        // home: const BottomNavBar(),
        );
  }
}
