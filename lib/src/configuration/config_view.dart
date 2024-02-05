import 'package:flutter/material.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:microbial_source_tracking/src/widgets/bluetooth_List.dart';
import 'package:microbial_source_tracking/src/widgets/config_app_bar.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({
    super.key,
    });

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  @override
  Widget build(BuildContext context) {
    //final List<BluetoothDevice> devices =  FlutterBluePlus.connectedDevices; //Using BluePlus for pulling connectedDevice information
    List<String> devices = <String>['Device 1', 'Device 2', 'Device 3', 'Device 4', 'Device 5'];
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
              bluetoothList(devices: devices),
            ],
          ),
        ),
      ),
    );    
  }
}



