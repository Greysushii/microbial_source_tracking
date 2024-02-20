import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

//RegisterAccount is the name of this widget
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
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),

              //Enter in their email (required)
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
                    hintText: "Enter Email...",
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
                  hintText: "Enter password...",
                  suffixIcon: IconButton(
                    icon: Icon(
                        passVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
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
              ),
            ),
            //Password confirmation, must be the same as above (required)
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userPassCheckTwo,
                obscureText: confirmVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  hintText: "Confirm password...",
                  suffixIcon: IconButton(
                    icon: Icon(confirmVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
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
              ),
            ),

            //Registration button
            /*const SizedBox(height: 20),
                  TextFormField(
                    //validator: (value)
                  )*/

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _validPass = validatePass(userPass.text);
                });
              },
              child: const Text('Validate Password'),
            ),
            _validPass
                ? const Text('Valid')
                : Text('Invalid password.\nRequirements:\n' '$_em'),
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
TextEditingController userPass = TextEditingController();
bool _validPass = false;
String _em = '';

//PassCheckOne is for the first password box, two is for the "confirm"
//Once confirmed, userPass will become the appropriate password
TextEditingController userPassCheckOne = TextEditingController();
TextEditingController userPassCheckTwo = TextEditingController();

//For showing/hiding the passwords
bool passVisible = false;
bool confirmVisible = false;

//Clears the passwords after not matching
void clearPassword() {
  userPassCheckOne.clear();
  userPassCheckTwo.clear();
}

final Map<RegExp, String> _validators = {
  RegExp(r'[A-Z]'): 'One uppercase',
  RegExp(r'[!@#\\$%^&*(),.?":{}|<>]'): 'One special character',
  RegExp(r'\\d'): 'One number',
  RegExp(r'^.{8,25}$'): 'Between 8 and 25 characters',
};

bool validatePass(String userPass) {
  //Reset error message
  _em = '';
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
  if (!userPass.contains(RegExp(r'[!@#\\$%^&*(),.?":{}|<>]'))) {
    _em += '• 1 special character.\n';
  }
  if (!userPass.contains(RegExp(r'\d'))) {
    _em += '• 1 number.\n';
  }

  return _em.isEmpty;
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
