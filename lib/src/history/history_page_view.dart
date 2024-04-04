import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPageView extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const HistoryPageView({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    String imageName = doc['title'];
    String imageURL = doc['imageURL'];
    String uploaderEmail = doc["uploader's email"];
    String uploaderFirstName = doc["uploader's first name"];
    String uploaderLastName = doc["uploader's last name"];
    String uploadTime =
        DateFormat('HH:mm').format(doc['uploadedDate'].toDate());
    double latitude = doc['latitude'];
    double longitude = doc['longitude'];

    return Scaffold(
        appBar: AppBar(title: Text('Image details')),
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 275,
                    child: Center(child: Image.network(imageURL)),
                  ),
                  const SizedBox(height: 10),
                  Text(imageName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Latitude: $latitude',
                      style: const TextStyle(fontSize: 18)),
                  Text('Longitude: $longitude',
                      style: const TextStyle(fontSize: 18)),
                  Text('Upload Time: $uploadTime',
                      style: const TextStyle(fontSize: 18)),
                  Text('Uploader\'s Email: $uploaderEmail',
                      style: const TextStyle(fontSize: 18)),
                  Text('Uploader\'s First Name: $uploaderFirstName',
                      style: const TextStyle(fontSize: 18)),
                  Text('Uploader\'s Last Name: $uploaderLastName',
                      style: const TextStyle(fontSize: 18))
                ],
              )),
        ));
  }
}
