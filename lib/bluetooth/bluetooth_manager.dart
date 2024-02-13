import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class BluetoothManager {
  
  final Map <String,dynamic> _device_slot1 = {"device": 0}
  final Map <String,dynamic> _device_slot2 = {"device": 0}

  void scanForDevices(BuildContext context) async {

    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);

    // verifier si les cartes sont en mode recherche
    if (capteurState.getSlot(1)["state"] != CapteurSlotState.recherche && capteurState.getSlot(2)["state"] != CapteurSlotState.recherche) {
      print("No slot in recherche mode");
      return;
    }

    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }


    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    await FlutterBluePlus.startScan(withNames: ["MyESP32"]);

    FlutterBluePlus.scanResults.listen((results) async {

      for (ScanResult device in results) {

        print("Found device: ${device.advertisementData.advName}");

        if (capteurState.getSlot(1)["state"] == CapteurSlotState.recherche) {
          capteurState.setSlotState(1, state: CapteurSlotState.trouve, nom: device.advertisementData.advName);
          await FlutterBluePlus.stopScan();
          return;
        } else if (capteurState.getSlot(2)["state"] == CapteurSlotState.recherche && capteurState.getSlot(1)["state"] != CapteurSlotState.trouve){
          capteurState.setSlotState(2, state: CapteurSlotState.trouve, nom: device.advertisementData.advName);
          await FlutterBluePlus.stopScan();
          return;
        }
        else {
          await FlutterBluePlus.stopScan();
          return;
        }
      }
    });
    await FlutterBluePlus.stopScan();

  }


  void stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  void connectDevice(BuildContext context, slot) async {
    // affecter a device la bonne info 
    var device = 
    // abonnement a device
    var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        print("${device.disconnectReasonCode} ${device.disconnectReasonDescription}");
      }
    });
  device.cancelWhenDisconnected(subscription, delayed:true, next:true);
  // connection de device
  try {
    await device.connect();
    print("Connected to device: ${device.nom}");

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      print("Service UUID: ${service.uuid}");
//remplacer characteristic par la characteristique que l'on veut observer
    });
    var characteristics = services.characteristics;
    for(BluetoothCharacteristic c in characteristics) {
      if (c.properties.read) {
          List<int> value = await c.read();
          print(value);
      }
    }
  }
  }
}

