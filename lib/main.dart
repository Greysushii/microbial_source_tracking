import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/themes/glwa_theme.dart';
import 'src/settings/settings_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override //This widget is the root of our application
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      debugShowCheckedModeBanner: false,
      theme: glwaTheme,
      home: const SettingsView(),
    );
  }
}