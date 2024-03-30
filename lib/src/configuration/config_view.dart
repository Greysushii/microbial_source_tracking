import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// class ConfigView extends StatelessWidget {
//   const ConfigView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Configuration"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             StreamBuilder<List<ScanResult>>(
//               stream: FlutterBluePlus.scanResults, 
//               initialData: [],
//               builder: (c, snapshot) => Column(
//                 children: snapshot.data!
//                     .map((result) => ListTile(
//                       title: Text(result.device.platformName == "" ? "No Device Name" : result.device.platformName),
//                       subtitle: Text(result.device.remoteId.toString()),
//                       onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                         result.device.connect();
//                         return LightController(device: result.device);
//                       })),
//                     ))
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: FlutterBluePlus.isScanning,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data!) {
//             return FloatingActionButton(
//               onPressed: () => FlutterBluePlus.stopScan(),
//               backgroundColor: Colors.lightBlue.shade700,
//               child: const Icon(Icons.stop),
//             );
//           } 
//           else {
//             return FloatingActionButton(
//               onPressed: () => FlutterBluePlus.startScan(
//                 timeout: const Duration(seconds: 5),
//               ),
//               backgroundColor: Colors.lightBlue.shade700,
//               child: const Icon(Icons.search),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class ConfigView extends StatefulWidget {
 ConfigView({Key? key, required this.title}) : super(key: key);
final String title;
@override
 _ConfigView createState() => _ConfigView();
}

class _ConfigView extends State<ConfigView> {
  String _pinState = 'off';
  void _sendCommand(String pinState) async {

    String url = 'https://a326-2600-1007-b056-c5f5-5c9-64a3-a2a2-bf45.ngrok-free.app//control'; //enter pyngrok generated url
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = jsonEncode({'pin_state': pinState});

    try{
      final response = await http.post(Uri.parse(url), headers: headers,body: body);
      if (response.statusCode == 200) {
        setState(() {
          _pinState = pinState;
        });
        print('Command sent successfully');
      } else {
        print('Command failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'GPIO Pin State:',
            ),
            Text(
              _pinState,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              _sendCommand('on');
            },
            child: const Text('Turn On'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                _sendCommand('off');
              }, 
              child: const Text('Turn Off'),
            ),
          ],
        )
      ),
    );
  }

}