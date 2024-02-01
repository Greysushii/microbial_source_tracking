import 'package:flutter/material.dart';

class HomeListView extends StatelessWidget {
  HomeListView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Bluetooth Devices',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: devices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 30,
                    child: Text('Bluetooth ${devices[index]}'),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Most Recent Pictures',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: recents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 30,
                    child: Text(recents[index]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ],
        ));
  }
}
