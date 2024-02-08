import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  PlatformFile? pickedFile;
  List<String> selectedFileList = [];

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    setState(() {
      selectedFileList.add(pickedFile!.name);
      // pickedFile = null; // once prototype 1 is put together, comment this out and uncomment the one under 'ref.putFile(file)'
    });

    final path = 'images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    pickedFile = null;
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
                    onPressed: selectFile,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully Uploaded!'),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_upload),
                        SizedBox(width: 9),
                        Text('Upload File'),
                      ],
                    ),
                  ),
                ],
              ),
              if (selectedFileList.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Uploaded Files',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: selectedFileList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.cloud_upload),
                              title: Text(selectedFileList[index]),
                              onTap: () {
                                showFile(selectedFileList[index]);
                              }
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}