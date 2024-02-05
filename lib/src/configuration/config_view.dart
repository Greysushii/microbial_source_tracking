import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/widgets/config_app_bar.dart';


class ConfigView extends StatefulWidget {
  const ConfigView({
    super.key,
    });

  // List<BluetoothDevice> devices = await FlutterBluePlus.systemDevices;
  // for (var d in devices) {
  //   async await d.connect(); // Must connect *our* app to the device
  //   async await d.discoverServices();
  // }

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25, 
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const configAppBar(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Bluetooth Devices',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                //itemCount: devices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      //title: Text('Bluetooth ${devices[index]}'),
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
            ],
          ),
        ),
      ),
    );    
  }
}

