// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/login/login_view.dart';
import '../widgets/password_reset_controller.dart';

class PasswordResetView extends StatelessWidget {
  const PasswordResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 248, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  SizedBox(height: 50),
                  Text(
                    'Enter your email to send a password reset',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),

                  //Register widget
                  PasswordReset(),
                  SizedBox(height: 20),
                ],
              )),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.topCenter,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('', style: TextStyle(fontSize: 20)),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            },
            child: const Text(
              'Return to login',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
        ]),
      ),
    );
  }
}
