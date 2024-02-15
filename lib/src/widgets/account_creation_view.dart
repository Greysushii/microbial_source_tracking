import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase_options.dart';

FirebaseAuth auth = FirebaseAuth.instance;

//Save the user's email and password when entering
TextEditingController userEmail = TextEditingController();
TextEditingController userPass = TextEditingController();

//PassCheckOne is for the first password box, two is for the "confirm"
//Once confirmed, userPass will become the appropriate password
TextEditingController userPassCheckOne = TextEditingController();
TextEditingController userPassCheckTwo = TextEditingController();

//Clears the passwords after not matching
void clearPassword() {
  userPassCheckOne.clear();
  userPassCheckTwo.clear();
}

Future<void> registerUser() async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail.text,
      password: userPass.text,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      if (kDebugMode) {
        print('The password provided is too weak.');
      }
    } else if (e.code == 'email-already-in-use') {
      if (kDebugMode) {
        print('The account already exists for that email.');
      }
    } else if (e.code == 'invalid-email') {
      if (kDebugMode) {
        print('Email address is badly formatted.');
      }
    } /* else {
      if (kDebugMode) {
        print('Registration successful!');
      }
    } */
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

//Email the user their verification code
var constructEmail = ActionCodeSettings(
  url: 'glwa-app.firebaseapp.com',
  handleCodeInApp: true,
  iOSBundleId: 'com.example.ios',
  androidPackageName: 'com.example.android',
);

var emailAuth = userEmail;

//Dialog box for passwords not matching
AlertDialog passNotMatch = const AlertDialog(
  title: Text("Registration error"),
  content: Text("Passwords do not match."),
);

//Nick, remember to cut down on reusing showdialog and alertdialog, look into
//condensing the code
AlertDialog passRegistration = const AlertDialog(
  title: Text("Success!"),
  content: Text("An email will be sent to the given email address."),
);

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({
    super.key,
  });
  //final String title;

  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<RegisterAccount> {
  //retrieve text from input
  final myController = TextEditingController();
  @override
  void dispose() {
    //clean up controller when widget is done using it.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Enter in their email (required)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userEmail,
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
                controller: userPassCheckOne,
                decoration: const InputDecoration(
                  labelText: 'Password *',
                ),
                //obscureText: true,
              ),
            ),

//Password confirmation, must be the same as above (required)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userPassCheckTwo,
                decoration: const InputDecoration(
                  labelText: 'Confirm password *',
                ),
                //obscureText: true,
              ),
            ),

            //Finalize registration button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //Check if passwords match, if yes, move onto authentication

                        if (userPassCheckOne.text == userPassCheckTwo.text) {
                          userPass = userPassCheckOne;
                          registerUser();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return passRegistration;
                              });

                          //If passwords do NOT match, retry.
                        } else {
                          clearPassword();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return passNotMatch;
                              });
                        }
                      },
                      child: const Text('Register')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
