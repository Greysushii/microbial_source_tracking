import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//RegisterAccount is the name of this widget, refer to RegisterAccount for routing purposes
class RegisterAccount extends StatefulWidget {
  const RegisterAccount({
    super.key,
  });
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
      backgroundColor: const Color.fromARGB(255, 233, 248, 255),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            //Enter in their First Name (required)
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userFirstName,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "First Name",
                ),
              ),
            ),

            //Enter in their Last Name (required)
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userLastName,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Last Name",
                ),
              ),
            ),

            //Enter in their email (required)
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
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

            //Initial password (required)
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                  controller: userPass,
                  obscureText: passVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: "Enter password",
                    suffixIcon: IconButton(
                      icon: Icon(passVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(
                          () {
                            //Toggle to show the contents of "Enter password"
                            passVisible = !passVisible;
                          },
                        );
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  //Check for password strength and show what is missing.
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return null;
                    }
                    if (strengthRequirements(text) == false) {
                      if (kDebugMode) {
                        //print("BAD PASS");
                      }
                      passStrength = false;
                      return _em;
                    }
                    if (strengthRequirements(text) == true) {
                      if (kDebugMode) {
                        //print("good pass");
                      }
                      passStrength = true;
                    }
                    return null;
                  }),
            ),

            //Password confirmation, must be the same as above (required)
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                  controller: userPassConfirm,
                  obscureText: confirmVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    hintText: "Confirm password",

                    //Show/hide contents of "Confirm password"
                    suffixIcon: IconButton(
                      icon: Icon(confirmVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(
                          () {
                            //Toggle to show the contents of "Confirm password"
                            confirmVisible = !confirmVisible;
                          },
                        );
                      },
                    ),

                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return null;
                    }
                    if (userPass.text != userPassConfirm.text) {
                      if (kDebugMode) {
                        //print("\tBAD CONFIRM");
                      }
                      passConfirm = false;
                    }
                    if (userPass.text == userPassConfirm.text) {
                      if (kDebugMode) {
                        //print("\tgood confirm");
                      }
                      passConfirm = true;
                    }
                    return null;
                  }),
            ),

            //Registration button
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    //Check if the values are the same, and if the boxes are not empty
                    if (kDebugMode) {
                      print("Strength $passStrength \nConfirm $passConfirm \n");
                    }
                    if (((passStrength & passConfirm) == true)) {
                      registerUser();
                      if (kDebugMode) {
                        print("\t\tEqual!");
                      }
                    }
                    if (((passStrength | passConfirm) == false)) {
                      //const Text('incorrect');
                      //clearPassword();
                      if (kDebugMode) {
                        print("\t\tINVALID ALL AROUND");
                      }
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return passNotMatch;
                        });
                  });
                },
                child: const Text('Sign Up', style: TextStyle(fontSize: 20)),
              ),
            ),
          ]),
        )),
      ),
    );
  }
}

//Functions!-------------------------------------------------------

FirebaseAuth auth = FirebaseAuth.instance;

//Save the user's email and password when entering
TextEditingController userEmail = TextEditingController();
TextEditingController userFirstName = TextEditingController();
TextEditingController userLastName = TextEditingController();
TextEditingController userPass = TextEditingController();

bool passStrength =
    false; //Initial password requirement check. default is false,
//true once the password field meets password strength requirement
bool passConfirm = false; //Once both passwords are equal, this becomes true

//Error message that appears when creating a password, holds all the requirements
//that slowly are removed as the strength requirements are met.
String _em = '';

//PassCheckOne is for the first password box, two is for the "confirm"
//Once confirmed, userPass will become the appropriate password
TextEditingController userPassCheckOne = TextEditingController();
TextEditingController userPassConfirm = TextEditingController();

//For showing/hiding the passwords
bool passVisible = true;
bool confirmVisible = true;

//Clears the passwords after not matching
void clearPassword() {
  userPass.clear();
  userPassConfirm.clear();
}

bool strengthRequirements(String userPass) {
  //Reset error message
  _em = '';
  //Returns true if any of these values "fail"
  if (userPass.length < 8) {
    _em += '• Minimum 8 characters.\n';
  }
  if (userPass.length > 20) {
    _em += '• Maximum 20 characters.\n';
  }
  if (!userPass.contains(RegExp(r'[A-Z]'))) {
    _em += '• 1 uppercase.\n';
  }
  if (!userPass.contains(RegExp(r'[a-z]'))) {
    _em += '• 1 lowercase.\n';
  }
  if (!userPass.contains(RegExp(r'[~!@#\\$%^&*(),.?":{}|<>]'))) {
    _em += '• 1 special character.\n';
  }
  if (!userPass.contains(RegExp(r'\d'))) {
    _em += '• 1 number.\n';
  }

  return _em.isEmpty;
}

Future<void> registerUser() async {
  try {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail.text,
      password: userPass.text,
    );
    //Create a key for the new user
    FirebaseFirestore.instance.collection('users').add({
      'first name': userFirstName.text.trim(),
      'last name': userLastName.text.trim(),
      'email': userEmail.text.trim(),
      // 'password' : userPass.text.trim(),
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      if (kDebugMode) {
        print('The password provided is too weak.');
      }
    } else if (e.code == 'email-already-in-use') {
      //registerAlert(1);
      if (kDebugMode) {
        print('Alert 1: The account already exists for that email.');
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



