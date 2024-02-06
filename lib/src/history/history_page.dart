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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
        centerTitle: true, 
        actions: [
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Uploaded!'),),);
            },
            child: const Row(
              children: [
                Icon(Icons.cloud_upload),
                SizedBox(width: 9),
                Text('Upload'),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
//          const SizedBox(height: 15), 
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              ElevatedButton(
//                onPressed: () {
//                  
//                },
//                style: ElevatedButton.styleFrom(
//                  
//                ),
//                child: const Text('Uploaded'),
//              ),
//              const SizedBox(width: 15),
//              ElevatedButton(
//                onPressed: () {
//                  
//                },
//                style: ElevatedButton.styleFrom(
//                ),
//               child: const Text('Received'),
//              ),
//            ],
//          ),
          const SizedBox(height: 10),
          if (selectedFileList.isNotEmpty)
            Column(
              children: [
                Text('Uploaded Files:',
                style: TextStyle(
                  fontSize: 25, 
                  fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height, // MediaQuery adjusts container height to fit whatever device is being used
                  child: ListView.builder(
                    itemCount: selectedFileList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                        leading: Icon(Icons.cloud_upload),
                        title: Text(selectedFileList[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
