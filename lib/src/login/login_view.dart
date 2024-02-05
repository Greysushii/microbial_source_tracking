import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:microbial_source_tracking/src/home/home_view.dart';
import 'package:microbial_source_tracking/src/widgets/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 248, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/images/glwa_logo.svg')),
                  const SizedBox(height: 50),
                  Text(
                    'Log in to your account',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),

                  // Login widget
                  Login(),

                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text('Forgot password?',
                                style: TextStyle(color: Colors.black)),
                          )
                        ]),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => HomeListView())));
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 52, 52, 52),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.topCenter,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Don\'t have an account? '),
          InkWell(
            onTap: () {},
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
