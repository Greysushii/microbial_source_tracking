import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase_options.dart';

FirebaseAuth auth = FirebaseAuth.instance;

//Save the user's email and password when entering
TextEditingController userEmail = TextEditingController();
TextEditingController userPass = TextEditingController();
TextEditingController userFirstName = TextEditingController();
TextEditingController userLastName = TextEditingController();

//PassCheckOne is for the first password box, two is for the "confirm"
//Once confirmed, userPass will become the appropriate password
TextEditingController userPassCheckOne = TextEditingController();
TextEditingController userPassCheckTwo = TextEditingController();

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Initialize the authentication emulator (For testing purposes!)
  // !!Commented out as this is in main.dart
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      if (kDebugMode) {
        print('User is currently signed out!');
      }
    } else {
      if (kDebugMode) {
        print("User is $user !");
      }
    }
  });
} // End of Main*/

//Clears the passwords after not matching
void clearPassword() {
  userPassCheckOne.clear();
  userPassCheckTwo.clear();
}

Future<void> registerUser() async {
  try {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail.text,
      password: userPass.text,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'firstname': userFirstName.text.trim(),
      'lastname': userLastName.text.trim(),
      'email': userEmail.text.trim(),
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      if (kDebugMode) {
        print('The password provided is too weak.');
      }
    } else if (e.code == 'email-already-in-use') {
      if (kDebugMode) {
        print('The account already exists for that email.');
      }
    } else {
      if (kDebugMode) {
        print('Registration successful!');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
// This widget is the root of your application. COMMENT THIS OUT BEFORE PUSHING!
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 97, 150, 237)),
        useMaterial3: true,
      ),
      home: const RegisterAccount(title: 'Registration'),
    );
  }
}*/

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({
    super.key,
  });
  //final String title;

  @override
  State<StatefulWidget> createState() => RegisterState();
}

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

//Below this line is alllllllllllll the visual stuff!

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
            // user enters first name
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userFirstName,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
            ),

            // user enters last name
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: TextFormField(
                controller: userLastName,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
            ),

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
