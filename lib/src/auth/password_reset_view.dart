// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/login/login_view.dart';
import '../widgets/password_reset_controller.dart';

class PasswordResetView extends StatelessWidget {
  const PasswordResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      backgroundColor: const Color.fromARGB(255, 233, 248, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  // SizedBox(height: 50),
                  SizedBox(height: 15),

                  //Register widget
                  PasswordReset(),
                  SizedBox(height: 20),
                ],
              )),
        ),
      ),
    );
  }
}
