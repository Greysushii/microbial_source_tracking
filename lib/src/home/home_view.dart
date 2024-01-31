import 'package:flutter/material.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0), child: Text('Bluetooth Devices')),
            Expanded(
                child: ListView(
              children: const [
                ListTile(title: Text("Bluetooth Device 1")),
                ListTile(title: Text("Bluetooth Device 2")),
                ListTile(title: Text("Bluetooth Device 3"))
              ],
            )),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Most Recent Pictures')),
            Expanded(
                child: ListView(
              children: const [
                ListTile(title: Text("012924_upload.jpg")),
                ListTile(title: Text("120223_upload.jpg")),
                ListTile(title: Text("122723_upload.jpg"))
              ],
            )),
          ],
        ));
  }
}
