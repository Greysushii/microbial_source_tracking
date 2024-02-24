import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountData extends StatefulWidget {
  const AccountData({super.key});

  @override
  State<AccountData> createState() => _AccountDataState();
}

class _AccountDataState extends State<AccountData> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Change $field'),
              content: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: "Enter new ${field.toLowerCase()}"),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Save')),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ));

    // Firebase interaction goes here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Data')),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 22),
              child: Text(
                'My Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () => editField('Email'),
                            icon: Icon(Icons.settings, color: Colors.grey))
                      ]),
                  Text(
                    user.email!,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),

            // edit first name
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'First Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () => editField('First Name'),
                            icon: Icon(Icons.settings, color: Colors.grey))
                      ]),
                  Text(
                    'First Name',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),

            // edit last name
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () => editField('Last Name'),
                            icon: Icon(Icons.settings, color: Colors.grey))
                      ]),
                  Text(
                    'Last Name',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),

            // edit password
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () => editField('Password'),
                            icon: Icon(Icons.settings, color: Colors.grey))
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
