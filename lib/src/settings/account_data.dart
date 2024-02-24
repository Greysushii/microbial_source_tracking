import 'package:cloud_firestore/cloud_firestore.dart';
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
        appBar: AppBar(title: const Text('Account Data')),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 22),
                    child: Text(
                      'My details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // user email
                  buildAccountDataCard(
                    title: 'Email',
                    value: user.email ?? '',
                    onEditPressed: () => editField('Email'),
                  ),

                  // user first name
                  buildAccountDataCard(
                      title: 'First name',
                      value: userData['firstname'] ?? '',
                      onEditPressed: () => editField('First Name')),

                  // user last name
                  buildAccountDataCard(
                      title: 'Last name',
                      value: userData['lastname'] ?? '',
                      onEditPressed: () => editField('Last Name')),

                  // password
                  buildAccountDataCard(
                      title: 'Password',
                      value: '********',
                      onEditPressed: () => editField('Password')),
                ],
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('No data available'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget buildAccountDataCard(
      {required String title,
      required String value,
      required VoidCallback onEditPressed}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 228, 228),
          borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
                onPressed: onEditPressed,
                icon: const Icon(Icons.settings, color: Colors.grey))
          ]),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
