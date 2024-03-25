// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:microbial_source_tracking/src/home/home_view.dart';
//import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;

//Save the user's email and password when entering
TextEditingController userEmail = TextEditingController();
TextEditingController userFirstName = TextEditingController();
TextEditingController userLastName = TextEditingController();
TextEditingController userPass = TextEditingController();
TextEditingController userPassConfirm = TextEditingController();

bool passStrength =
    false; //Initial password requirement check. default is false,
//true once the password field meets password strength requirement
bool passConfirm = false; //Once both passwords are equal, this becomes true

bool uniqueEmail = true;

//Hide the sign up button until all fields are filled
bool checkButton() {
  if ((userEmail.text.isEmpty |
      userFirstName.text.isEmpty |
      userLastName.text.isEmpty |
      userPass.text.isEmpty |
      userPassConfirm.text.isEmpty)) {
    return false;
  } else {
    return true;
  }
}

//RegisterAccount is the name of this widget,
//refer to RegisterAccount for routing purposes
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

  Future<void> alertMessage(int issue) async {
    String issueTitle = " ";
    String issueContent = " ";
    String textForButton = "Return";

    switch (issue) {
      case 0:
        issueTitle = "Default error";
        issueContent = "This is the default error.";
        break;
      case 1:
        issueTitle = "Empty fields";
        issueContent = "Please fill out all fields.";
        break;
      case 2:
        issueTitle = "Password is too weak.";
        issueContent =
            "To ensure a strong password, make sure that the Password Strength fields are gone when submitting.";
        break;
      case 3:
        issueTitle = "Passwords do not match";
        issueContent = "Please make sure both passwords are the same.";
        break;
      case 4:
        issueTitle = "Email in use.";
        issueContent =
            "This email is already in use. Please enter a different email, or use 'Forgot password' on the login screen";
        break;
      case 5:
        issueTitle = "Success";
        issueContent = "Welcome to our app!";
        textForButton = "Home page";
        break;
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
                if (issue == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                  //Navigator.of(context).pop();
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

  Future<void> registerUser() async {
    try {
      // ignore: unused_local_variable
      final UserCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail.text,
        password: userPass.text,
      );

      FirebaseFirestore.instance.collection('users').doc(UserCredential.user!.uid).set(
        {
          'firstname': userFirstName.text.trim(),
          'lastname': userLastName.text.trim(),
          'email': userEmail.text.trim().toLowerCase(),
        }
      );

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          uniqueEmail = false;
          break;
        case "invalid-email":
          uniqueEmail = false;
          break;
      }
    } catch (e) {
      //uniqueEmail = false;
      if (kDebugMode) {
        print(e);
      }
    }

    //sendLink();
    // emailCheckAndStore();
  }

/*Add the user into the user collections in Firebase. This is called after the 
  registerUser() function, regardless of the email being valid. This is due to
  the "check" in the name, as if the email is in use or poorly formated, it will
  pass uniqueEmail = false, giving the email error message (4). Otherwise, as 
  all the other checks prior (password strength, etc.) are checked and the email
  is valid, add their information into the DB, show registration success alert,
  then move them to the home page.
*/
  Future<void> emailCheckAndStore() async {
    switch (uniqueEmail) {
      case (true):
        FirebaseFirestore.instance.collection('users').add({
          'firstname': userFirstName.text.trim(),
          'lastname': userLastName.text.trim(),
          'email': userEmail.text.trim().toLowerCase(),
        });
        alertMessage(5);
        break;
      case (false):
        alertMessage(4);
        break;
    }
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
            //Enter in their First Name (required)------------------------------
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

            //Enter in their Last Name (required)-------------------------------
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

            //Enter in their email (required)-----------------------------------
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

            //Initial password (required)---------------------------------------
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

            //Password confirmation, must be the same as above (required)-------
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
                      if (kDebugMode) {}
                      passConfirm = false;
                    }
                    if (userPass.text == userPassConfirm.text) {
                      if (kDebugMode) {}
                      passConfirm = true;
                    }
                    return null;
                  }),
            ),

            //Registration button-----------------------------------------------
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
                    //User entered nothing
                    if (((checkButton()) == false)) {
                      alertMessage(1);
                    }
                    //User entered a weak password. Reset password and try again
                    else if (((passStrength) == false)) {
                      alertMessage(2);
                      clearPassword();
                    }
                    //Password meets strength, but are not equal
                    else if (((passConfirm) == false)) {
                      alertMessage(3);
                      clearPassword();
                    }
                    //Password is strong, both are equal, and email is unique
                    else if (((passStrength & passConfirm) == true)) {
                      registerUser();
                      uniqueEmail = true;
                    }
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

//Functions!--------------------------------------------------------------------

//Error message that appears when creating a password, holds all the requirements
//that slowly are removed as the strength requirements are met.
  String _em = '';

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

  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'glwa-app.web.app',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');
  void sendLink() {
    FirebaseAuth.instance.sendSignInLinkToEmail(
        email: userEmail.text
        // ignore: avoid_print
        ,
        actionCodeSettings: acs);
  }

/*var emailAuth = 'someemail@domain.com';
FirebaseAuth.instance.sendSignInLinkToEmail(
        email: emailAuth, actionCodeSettings: acs)
    .catchError((onError) => print('Error sending email verification $onError'))
    .then((value) => print('Successfully sent email verification'));*/

//Dialog box for passwords not matching
  AlertDialog passNotMatch = const AlertDialog(
    title: Text("Registration error"),
    content: Text("Passwords do not match."),
  );

/* //Dialog box for passwords not matching
AlertDialog passNotMatch = const AlertDialog(
  title: Text("Registration error"),
  content: Text("Passwords do not match."),
); */
}
