import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:microbial_source_tracking/src/login/login_view.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({
    super.key,
  });
  @override
  State<PasswordReset> createState() => PasswordResetState();
}

class PasswordResetState extends State<PasswordReset> {
  TextEditingController userEmail = TextEditingController();

  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      //throw Exception(err.message.toString());
      alertMessage(7);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> alertMessage(int issue) async {
    String issueTitle = " ";
    String issueContent = " ";
    String textForButton = "Return";

    switch (issue) {
      case 6:
        issueTitle = "Password reset sent";
        issueContent =
            "If ${userEmail.text} exists within our database, a password reset link will appear in your inbox.";
        textForButton = "Return to login";
      case 7:
        issueTitle = "No email provided";
        issueContent = "Please enter a valid email address";
        textForButton = "Return";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(issueTitle, style: TextStyle(fontSize: 25)),
          content: Text(issueContent, style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (issue == 6) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(textForButton, style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        //Enter in their First Name (required)------------------------------
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextFormField(
              controller: userEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter Email",
              ),
              //Hints telling user what is missing.
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "Please enter your email.";
                }
                if (!text.contains('@')) {
                  return "Email address must contain an @.";
                }
                return null;
              }),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              if (userEmail.text.isEmpty ||
                  !userEmail.text.contains('@') ||
                  !userEmail.text.contains('.')) {
                alertMessage(7);
              } else {
                forgotPassword(email: userEmail.text);
                alertMessage(6);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 52, 52, 52),
                borderRadius: BorderRadius.circular(8)),
            child: const Center(
                child: Text(
              'Send password reset',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        )
      ]),
    ));
  }
}