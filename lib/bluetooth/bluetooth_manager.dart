import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class BluetoothManager {


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

      for (ScanResult r in results) {

        print("Found device: ${r.advertisementData.advName}");

        if (capteurState.getSlot(1)["state"] == CapteurSlotState.recherche) {
          capteurState.setSlotState(1, state: CapteurSlotState.trouve, nom: r.advertisementData.advName);
          await FlutterBluePlus.stopScan();
          return;
        } else if (capteurState.getSlot(2)["state"] == CapteurSlotState.recherche && capteurState.getSlot(1)["state"] != CapteurSlotState.trouve){
          capteurState.setSlotState(2, state: CapteurSlotState.trouve, nom: r.advertisementData.advName);
          await FlutterBluePlus.stopScan();
          return;
        }
        else {
          await FlutterBluePlus.stopScan();
          return;
        }
      }
    });
  }


  void stopScan() async {
    await FlutterBluePlus.stopScan();
  }

}
