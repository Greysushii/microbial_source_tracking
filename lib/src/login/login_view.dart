import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:microbial_source_tracking/src/home/home_view.dart';
import 'package:microbial_source_tracking/src/widgets/account_creation_view.dart';
import 'package:microbial_source_tracking/src/widgets/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                children: [
                  const SizedBox(height: 10),
                  Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/images/glwa_logo.svg')),
                  const SizedBox(height: 50),
                  const Text(
                    'Log in to your account',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),

                  // Login widget
                  const Login(),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Text('Forgot password?',
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
                              builder: ((context) => const HomeView())));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 52, 52, 52),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
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
          const Text('Don\'t have an account? '),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterAccount(),
                ),
              );
            },
            child: const Text(
              'Sign up here',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
    );
  }
}
