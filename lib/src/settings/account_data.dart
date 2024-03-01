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
  TextEditingController newValue = TextEditingController();

  void clearText() {
    newValue.clear();
  }

  Future<void> updateUser(String field) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({field: newValue.text.trim()})
        .then((value) => print('user updated'))
        .catchError((error) => print('failed to update user: $error'));
  }

  Future<void> updateEmail() {
    return user
        .verifyBeforeUpdateEmail(newValue.text.trim())
        .then((value) => print('user email updated'))
        .catchError((error) => print('failed to update user: $error'));
  }

  Future<void> updatePassword() {
    return user
        .updatePassword(newValue.text.trim())
        .then((value) => print('user email updated'))
        .catchError((error) => print('failed to update user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Account Data')),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  // user email
                  buildAccountDataCard(
                    title: 'Email',
                    value: userData['email'] ?? '',
                    onEditPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Change email'),
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Enter new email'),
                          controller: newValue,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                {clearText(), Navigator.pop(context)},
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {
                              updateEmail(),
                              updateUser('email'),
                              clearText(),
                              Navigator.pop(context)
                            },
                            child: const Text('Save'),
                          )
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),

                  // user first name
                  buildAccountDataCard(
                      title: 'First name',
                      value: userData['firstname'] ?? '',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change first name'),
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter new name'),
                                controller: newValue,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    updateUser('firstname'),
                                    clearText(),
                                    Navigator.pop(context)
                                  },
                                  child: const Text('Save'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),

                  // user last name
                  buildAccountDataCard(
                      title: 'Last name',
                      value: userData['lastname'] ?? '',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change last name'),
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter new name'),
                                controller: newValue,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    updateUser('lastname'),
                                    clearText(),
                                    Navigator.pop(context),
                                  },
                                  child: const Text('Save'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),

                  // password
                  buildAccountDataCard(
                      title: 'Password',
                      value: '********',
                      onEditPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Change password'),
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: 'Enter new password'),
                                controller: newValue,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      {clearText(), Navigator.pop(context)},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    updatePassword(),
                                    Navigator.pop(context)
                                  },
                                  child: const Text('Save'),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )),
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
