// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:microbial_source_tracking/src/home/how_to/how_to_bluetooth.dart';
import 'package:microbial_source_tracking/src/home/how_to/how_to_configure.dart';
import 'package:microbial_source_tracking/src/home/how_to/how_to_files.dart';
import 'package:microbial_source_tracking/src/home/how_to/how_to_start_test.dart';
import 'package:microbial_source_tracking/src/themes/glwa_theme.dart';

class HomeListView extends StatefulWidget {
  const HomeListView({super.key});

  @override
  State<HomeListView> createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
  //Test information to show flow of data
  /* final List<String> devices = <String>['Device 1', 'Device 2', 'Device 3'];
  final List<String> recents = <String>[
    'lakestclair_022024.jpg',
    'lakehuron_122723.jpg',
    'lakehuron_122623.jpg',
    'lakestclair_012924.jpg',
    'lakestclair_012824.jpg',
    'detroitriver_121523.jpg',
    'lakestclair_112723.jpg',
    'detroitriver_112923.jpg',
    'detroitriver_010224.jpg',
    'lakestclair_010324.jpg',
    'lakehuron_121323.jpg',
  ]; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          // backgroundColor: glwaTheme.secondaryHeaderColor,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset("assets/images/glwa_logo.svg"),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Welcome to Microbial Source Tracking!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Click on the cards below to get started.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HowToBluetooth())));
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: glwaTheme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black))),
                  child: const Center(
                    child: Text(
                      'How to Connect to a Bluetooth Device',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HowToConfigure())));
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: glwaTheme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black))),
                  child: const Center(
                    child: Text(
                      'How to Configure a Device',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HowToStartTest())));
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: glwaTheme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black))),
                  child: const Center(
                    child: Text(
                      'How to Start a Test',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HowToFiles())));
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: glwaTheme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black))),
                  child: const Center(
                    child: Text(
                      'How to Select and Upload a File',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          /* child: Column(
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
                child: Text('Most Recent Experimental Data',
                child: Text('Most Recent Experimental Data',
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
        )*/
        ));
  }
}
