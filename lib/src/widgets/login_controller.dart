// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/home/home_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool wrongCredentials = false;

  Future signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        setState(() {
          wrongCredentials = true;
        });
      }
    }
    if (wrongCredentials == true) {
      if (kDebugMode) print(':(');
    } else {
      if (kDebugMode) print('You in!!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    }
    wrongCredentials = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter email here...",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: TextFormField(
                controller: passwordController,
                obscureText: passVisible,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter password here...",
                  //Show/hide contents of "Confirm password"
                  suffixIcon: IconButton(
                    icon: Icon(
                        passVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          //Toggle to show the contents of "Enter password"
                          passVisible = !passVisible;
                        },
                      );
                    },
                  ),
                ),
                //obscureText: true,
              ),
            ),
            const SizedBox(height: 10),

            // Text appears when incorrect credentials appear
            if (wrongCredentials)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Incorrect username or password',
                      style: TextStyle(color: Colors.red, fontSize: 17))
                ]),
              ),

            const SizedBox(height: 10),

            // Sign in button
            GestureDetector(
              onTap: (signUserIn),
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 100),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 52, 52, 52),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                    child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool passVisible = true;
