import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedSection = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
        centerTitle: true, 
        actions: [
          TextButton(
            onPressed: () {
              localImage(context);
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
          const SizedBox(height: 15), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  onButtonPressed('Uploaded');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSection == 'Uploaded'
                      ? Colors.green
                      : null,
                ),
                child: const Text('Uploaded'),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  onButtonPressed('Received');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSection == 'Received'
                      ? Colors.green
                      : null,
                ),
                child: const Text('Received'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
                selectedSection == 'Uploaded'
                ? 'Area for upload history'
                : selectedSection == 'Received'
                ? 'Area for received history'
                : 'Select a history option',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      selectedSection = buttonText; // for highlighting whatever section the user is on (Uploaded History or Received History)
    });
  }
}

Future<void> localImage(BuildContext context) async {
  final imageChoice = ImagePicker(); 
  await imageChoice.pickImage(source: ImageSource.gallery); // this allows access to local storage
}