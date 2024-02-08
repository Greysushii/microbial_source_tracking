// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeListView extends StatefulWidget {
  const HomeListView({super.key});

  @override
  State<HomeListView> createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
  //Test information to show flow of data
  final List<String> devices = <String>['Device 1', 'Device 2', 'Device 3'];
  final List<String> recents = <String>[
    '012924_upload.jpg',
    '120223_upload.jpg',
    '122723_upload.jpg',
    '012724_upload.jpg',
    '012824_upload.jpg',
    '121523_upload.jpg',
    '112723_upload.jpg',
    '112923_upload.jpg',
    '010224_upload.jpg',
    '010324_upload.jpg',
    '121323_upload.jpg',
  ];

  // void signUserOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Bluetooth Devices',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: devices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text('Bluetooth ${devices[index]}'),
                      onTap: () {
                        const snackBar = SnackBar(
                            content: Text('Bluetooth device is connected!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  );
                },
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Most Recent Pictures',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: recents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    title: Text(recents[index]),
                    onTap: () {
                      const snackBar =
                          SnackBar(content: Text('Accessing image...'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ));
                },
              ),
            ),
          ],
        )));
  }
}
