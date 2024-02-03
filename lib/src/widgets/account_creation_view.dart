import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 97, 150, 237)),
        useMaterial3: true,
      ),
      home: const RegisterAccount(title: 'Registration'),
    );
  }
}

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<RegisterAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Register", style: TextStyle(fontSize: 36)),

            //Enter in their email (required)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email *',
                ),
              ),
            ),

            //Initial password (required)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password *',
                ),
                obscureText: true,
              ),
            ),

            //Password confirmation, must be the same as above (required)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm password *',
                ),
                obscureText: true,
              ),
            ),

            //Finalize registration
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Register')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}