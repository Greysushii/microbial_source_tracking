import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountData extends StatefulWidget {
  const AccountData({super.key});

  @override
  State<AccountData> createState() => _AccountDataState();
}

class _AccountDataState extends State<AccountData> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Data')),
      body: SafeArea(
        child: ListView(
          children: [
            // Text('My Details'),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email'),
                        Icon(Icons.settings, color: Colors.grey)
                      ]),
                  Text(user.email!)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name'),
                        Icon(Icons.settings, color: Colors.grey)
                      ]),
                  Text('Name goes here')
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Password'),
                        Icon(Icons.settings, color: Colors.grey)
                      ]),
                  Text('Change password here')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
