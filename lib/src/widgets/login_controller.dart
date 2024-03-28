// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/auth/auth_page.dart';
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

/*Nick: I was testing signing in, and was able to do so without even entering
  a value. The e.codes here are messy, but I just wanted to make sure no error
  got passed...going to need to clean this up before the final! */
  Future signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' ||
          e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'channel-error' ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        setState(() {
          wrongCredentials = true;
        });
      }
    }
    if (wrongCredentials == true) {
      alertMessage();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    }
    wrongCredentials = false;
  }

  Future<void> alertMessage() async {
    String issueTitle = "Invalid email or password";
    String issueContent = "Please check your spelling and try again.";
    String textForButton = "Return";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(issueTitle, style: TextStyle(fontSize: 24)),
          content: Text(issueContent, style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(textForButton, style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
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
