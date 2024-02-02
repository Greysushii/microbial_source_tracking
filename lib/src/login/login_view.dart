import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/images/glwa_logo.svg')),
                  const SizedBox(height: 30),
                  Text(
                    'Login to your account',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Login widget goes here',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Login button goes here',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Don\'t have an account? '),
          InkWell(
            child: Text(
              'Sign up here',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
    );
  }
}
