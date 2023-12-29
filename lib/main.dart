import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:keeping_fit/auth/main_page.dart';
import 'package:keeping_fit/pages/home_page.dart';
import 'package:keeping_fit/pages/log_in_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
