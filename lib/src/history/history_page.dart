import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';


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
     
    final path = 'images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    String? waterSource = await getWaterSource(); 

    if (waterSource != null) {
        final ref = FirebaseStorage.instance.ref().child(path);
        TaskSnapshot firebaseStorageUpload = await ref.putFile(file); // waiting for FB storage upload to complete before grabbing URL

        String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";

        DocumentSnapshot currentUserInfo = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: 'NotHeisenberg@yahoo.com').get()
            .then((QuerySnapshot querySnapshot) => querySnapshot.docs.first);
        
        
        final image = <String, dynamic>{ 
            "title": DateFormat('MMddyyyy').format(actualDate),
            "uploadedDate": FieldValue.serverTimestamp(), // grabs timestamp when doc was uploaded
            "imageURL": await firebaseStorageUpload.ref.getDownloadURL(),
            "lake": waterSource,
            "uploader's email": currentUserEmail, 
            "uploader's first name": currentUserInfo['first name'], 
            "uploader's last name": currentUserInfo['last name']
          };

        db.collection("images").add(image).then((DocumentReference doc) => // adds doc created above to collection 
        print('DocumentSnapshot added with ID: ${doc.id}'));

        pickedFile = null;

        ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File Uploaded!'),
              ),
            );
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

  Future showFile(String fileName) async {
      
    var response = await FirebaseStorage.instance.ref('images/$fileName').getDownloadURL();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(response),
        );
      },
    );
    
  }
  
  DateTime currentDate = DateTime.now(); // using DateTime class to grab current date, which can be modified in the DatePicker below for filtering purposes
  DateTime actualDate = DateTime.now();
  
  Stream<QuerySnapshot> getDocumentStream() { // function for filtering documents based on the user's preferred date range then building stream
    DateTime start = DateTime(currentDate.year, currentDate.month, currentDate.day); // define start of range for filtering documents by date
    DateTime end = start.add(Duration(days: 1)); // define end of range for document filtering by date

    return FirebaseFirestore.instance.collection('images').where('uploadedDate', isGreaterThanOrEqualTo: start).where('uploadedDate', isLessThan: end).snapshots();
    // returning docs fitting the desired date range
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        TextButton( 
                          child: Text(
                            'Upload Date: ${DateFormat('MM-dd-yyyy').format(currentDate)}', // shows user the current selected date range with yyyy-mm-dd format
                          ),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker( // From flutter material library: creates drop-down calendar for user to pick date
                              context: context,                              
                              initialDate: currentDate,   // user opens calendar, first sees currently set date (Today if filter date not set yet)
                              firstDate: DateTime(2000), // starting year for calendar
                              lastDate: DateTime.now(), // ending date (today's date)
                            );
                            if (pickedDate != null) {
                              setState(() {
                                currentDate = pickedDate; // changes current date for filter based on user input
                              });
                            }
                          },
                        ),
                        Icon(Icons.date_range),
                      ],
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                      onPressed: () {
                      selectFile();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 9),
                        Text('Select File'),
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
                        Text('Upload File'),
                      ],
                    ),
                  )],),

              StreamBuilder<QuerySnapshot>(
                stream: getDocumentStream(),
                builder: (context, snapshot) {
                  List<QueryDocumentSnapshot> documents = snapshot.data?.docs ?? [];

                  if (documents.isEmpty) {
                    return Text('No documents found with current filters.');
                  }

                  return Column(
                    children: documents.map((doc) {
                      String imageName = doc['title'];
                      String documentID = doc.id; // reference in case of deleting
                      String imageURL = doc['imageURL']; // reference in case of deleting

                      return Card(
                        child: ListTile(
                          title: Text('$imageName'),
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