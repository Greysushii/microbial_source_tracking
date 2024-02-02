import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  const Login({super.key, required this.title});
  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override

    Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Log In / Sign Up"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50,),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter username here...",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50,),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter password here...",
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: const Text('Log In'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: const Text('Sign Up'),
                ),
              ],
             ),
            ),
          ],
        ),
      ),
    );
  }
}