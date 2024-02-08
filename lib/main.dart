// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/auth/auth_page.dart';
// import 'package:microbial_source_tracking/src/login/login_view.dart';
import 'package:microbial_source_tracking/src/themes/glwa_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override // This widget is the root of our application
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      debugShowCheckedModeBanner: false,
      theme: glwaTheme,
      home: AuthPage(), // Fill in the page you are working on here to test
    );
  }
}
