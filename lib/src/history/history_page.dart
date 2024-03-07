import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final db = FirebaseFirestore.instance; // Cloud firestore instance! 

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Selected!'),
        ),
      );
      
   });
  
  }


  Future uploadFile() async {
    
    var locationPermissionStatus = await Permission.location.request();

    if (locationPermissionStatus == PermissionStatus.granted) {
      final path = 'images/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      String? waterSource = await getWaterSource();

      if (waterSource != null) {
        
        final ref = FirebaseStorage.instance.ref().child(path);
        TaskSnapshot firebaseStorageUpload = await ref.putFile(file); // waiting for FB storage upload to complete before grabbing URL

        String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: currentUserEmail).get();
        
        DocumentSnapshot currentUserInfo = querySnapshot.docs.first;

        String uploadedDate = DateFormat('MM-dd-yyyy').format(actualDate);
  
        var userLocation = await Geolocator.getCurrentPosition();

        final image = <String, dynamic>{
          "title": '$waterSource $uploadedDate',
          "uploadedDate": FieldValue.serverTimestamp(),
          "imageURL": await firebaseStorageUpload.ref.getDownloadURL(),
          "lake": waterSource,
          "uploader's email": currentUserEmail,
          "uploader's first name": currentUserInfo['firstname'],
          "uploader's last name": currentUserInfo['lastname'],
          "latitude": userLocation.latitude, 
          "longitude": userLocation.longitude, 
        };

        await db.collection("images").add(image).then((DocumentReference doc) { // adds doc created above to collection
          print('DocumentSnapshot added with ID: ${doc.id}');
          
          setState(() {
            pickedFile = null;
          });

        });
        

        

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File Uploaded!'),
          ),
        );
      }
    }
  }

  Future getWaterSource() async {
    TextEditingController waterSourceController = TextEditingController(); 

    return showDialog<String>(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sample Retrieved From: '),
          content: TextField(
            controller: waterSourceController, 
            decoration: InputDecoration(hintText: 'Lake Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.pop(context, waterSourceController.text);
              }
            ),
          ],
        );
      },
    );
  }

  Future showFile(QueryDocumentSnapshot doc) async {

      String imageName = doc['title'];
      String imageURL = doc['imageURL'];
      String uploaderEmail = doc["uploader's email"];
      String uploaderFirstName = doc["uploader's first name"];
      String uploaderLastName = doc["uploader's last name"];
      String uploadTime = DateFormat('HH:mm').format(doc['uploadedDate'].toDate());
      double latitude = doc['latitude'];
      double longitude = doc['longitude'];
      
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            padding: const EdgeInsets.all(8.0), 
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            Image.network(imageURL),
            SizedBox(height: 10),
            Text('$imageName'), 
            Text('Latitude: $latitude'), 
            Text('Longitude: $longitude'),
            Text('Upload Time: $uploadTime'),
            Text('Uploader\'s Email: $uploaderEmail'),
            Text('Uploader\'s First Name: $uploaderFirstName'),
            Text('Uploader\'s Last Name: $uploaderLastName')
            ],
            )
          )
        );
      },
    );
    
  }

  Future showSelectedFile() async {
    if (pickedFile != null) {
      File file = File(pickedFile!.path!);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(file),
          );
        },
      );
    }
  }

  Future getLakeOptions() async {

    QuerySnapshot lakeQuery = await FirebaseFirestore.instance.collection('images').orderBy('lake').get();

    List<String> lakeOptions = lakeQuery.docs.map((doc) => (doc['lake'] as String?) ?? "").toSet().toList();

    return lakeOptions;

  }

  Future openLakeOptions() async {
    
    List<String> selectedLakes = [];

    List<String> lakeChoices = await getLakeOptions();


    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Lakes'),
          children: [
            SingleChildScrollView(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                children: lakeChoices.map((lake) {
                  return CheckboxListTile(
                    title: Text(lake),
                    value: selectedLakes.contains(lake),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedLakes.add(lake);
                        } else {
                          selectedLakes.remove(lake);
                        }
                      });
                    },
                  );
                }).toList(),
              );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Done'),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result != null && result) {
      print('Selected Lakes: $selectedLakes');
    }

    
  }
  
  DateTime currentDate = DateTime.now(); // using DateTime class to grab current date, which can be modified in the DatePicker below for filtering purposes
  DateTime actualDate = DateTime.now();

  bool showAllDocuments = true;
  
  Stream<QuerySnapshot> getDocumentStream() { // function for filtering documents based on the user's preferred date range then building stream

    if (showAllDocuments == true) {
      return FirebaseFirestore.instance.collection("images").orderBy('uploadedDate', descending: true).snapshots();
    }

    else {

    
      DateTime start = DateTime(currentDate.year, currentDate.month, currentDate.day); // define start of range for filtering documents by date
      DateTime end = start.add(Duration(days: 1)); // define end of range for document filtering by date

      return FirebaseFirestore.instance.collection('images').where('uploadedDate', isGreaterThanOrEqualTo: start).where('uploadedDate', isLessThan: end).orderBy('uploadedDate', descending: true).snapshots();
      // returning docs fitting the desired date range
  
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('History'),
    ),
    body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_upload),
                      SizedBox(width: 9),
                      Text('Select File', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    uploadFile();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_upload),
                      SizedBox(width: 9),
                      Text('Upload File', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ],
            ),

            
            pickedFile != null ?
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    child: ListTile(
                        title: Text(
                          'Selected file: ${pickedFile!.name}', 
                           textAlign: TextAlign.center),
                        onTap: () {
                          showSelectedFile(); 
                        },
                      ),
                  ),
                )
            : Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Card(
                    child: ListTile(
                        title: Text(
                          'Selected file appears here',
                          style: TextStyle( 
                            fontStyle: FontStyle.italic,
                          ),          
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      TextButton(
                        child: const Row( 
                          children: [ 
                            Icon(Icons.date_range), 
                            Text(
                              "Select Date", 
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                            )
                          ]
                        ),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: currentDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              currentDate = pickedDate;
                              showAllDocuments = false; 
                            });
                          } else {
                            setState(() {
                              showAllDocuments = true; 
                            });
                          }
                        },
                      ),
                      TextButton( 
                        child: const Row( 
                          children: [ 
                            Icon(Icons.location_on),
                            Text("Select Location"), 
                          ]
                        ), 
                        onPressed: () {
                           openLakeOptions();
                        } 
                      ),
                    ],
                  ),
                ),
                TextButton(
                  child: Text('Reset'),
                  onPressed: () {
                    setState(() {
                      showAllDocuments = true; 
                    });
                  },
                ),
              ],   
            ),
              Text( 
                showAllDocuments ? 'All History' : 'History From: ${DateFormat('MM-dd-yyyy').format(currentDate)}', 
                style: TextStyle(fontSize: 18)
              ),
            
            StreamBuilder<QuerySnapshot>(
              stream: getDocumentStream(),
              builder: (context, snapshot) {
                List<QueryDocumentSnapshot> documents = snapshot.data?.docs ?? [];

                if (documents.isEmpty) {
                  return Text('No files found.');
                }

                return Column(
                  children: documents.map((doc) {
                    String imageName = doc['title'];
                    String documentID = doc.id; // reference in case of deleting
                    String imageURL = doc['imageURL']; // reference in case of deleting

                    return Card(
                      child: ListTile(
                        title: Text('$imageName'),
                        onTap: () {
                          showFile(doc);
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            bool deletionConfirmation = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text('Are you sure you want to delete this file?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (deletionConfirmation == true) {
                              await db.collection("images").doc(documentID).delete();
                              await FirebaseStorage.instance.refFromURL(imageURL).delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('File Deleted'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

}
// search bar: search by date, location, and person who took the data. Nothing else is needed