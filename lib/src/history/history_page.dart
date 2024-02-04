import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HistoryPage(),
    );
  }
}

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
    pickedFile = null;
  });
  final path = 'images/${pickedFile!.name}';
  final file = File(pickedFile!.path!);

  final ref = FirebaseStorage.instance.ref().child(path); 
  ref.putFile(file);

  
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
            onPressed: uploadFile,
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
                  height: 500, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: selectedFileList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.cloud_upload),
                        title: Text(selectedFileList[index]),
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
  
//if (pickedFile != null)
  //              Expanded(
    //              child: Container(
      //              color: Colors.blue[100],
        //            child: Center(
          //            child: Text(pickedFile!.name),
            //          ),
              //      ),
                //  ),
                
  //ListView(
    //            for (var pair in appState.favorites)
      //    ListTile(
        //    leading: Icon(Icons.favorite), 
          //  title: Text(pair.asLowerCase),
         // )
  //)