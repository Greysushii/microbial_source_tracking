import 'dart:io';
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
  List<String> selectedFileList = [];

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
    final ref = FirebaseStorage.instance.ref().child(path);
    TaskSnapshot firebaseStorageUpload = await ref.putFile(file); // waiting for FB storage upload to complete before grabbing URL 

    final image = <String, dynamic>{ // creates a test document with fields 
      "title": "I love glwa",
      "uploadedDate": FieldValue.serverTimestamp(), // grabs timestamp when doc was uploaded
      "imageURL": await firebaseStorageUpload.ref.getDownloadURL()
    };

    db.collection("images").add(image).then((DocumentReference doc) => // adds that test doc created above to collection 
    print('DocumentSnapshot added with ID: ${doc.id}'));

    pickedFile = null;

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Uploaded!'),
        ),
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
  
  DateTime currentDate = DateTime.now(); // using DateTime class to grab current date

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
                            'Filter By Date: ${DateFormat('MM-dd-yyyy').format(currentDate)}', // shows user the current selected date range with yyyy-mm-dd format
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

          StreamBuilder<QuerySnapshot>( // StreamBuilder listens to the Stream above
            stream: getDocumentStream(), // calls getDocumentStream() for filtered document display
            builder: (context, snapshot) {
              List<QueryDocumentSnapshot> documents = snapshot.data?.docs ?? []; // puts the acquired filtered docs in list, avoiding null reference error by defaulting to an empty list
              if (documents.isEmpty) {
                return Text('No documents found with current filters.'); // if no docs are present tells user
              }

              return Column(
              children:
                documents.map((doc) { // map applies the function to all docs in the document List
                String imageName = doc['title'];
                return ListTile( 
                  title: Text('$imageName'), 
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {

                    },
                  )
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