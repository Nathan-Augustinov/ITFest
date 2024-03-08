import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/firebase_options.dart';
import 'package:it_fest/screens/home/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      home: const BottomNavBar(),
    );
  }
}
