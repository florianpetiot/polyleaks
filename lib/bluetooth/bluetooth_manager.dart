import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class BluetoothManager {
  static final BluetoothManager _singleton = BluetoothManager._internal();

  factory BluetoothManager() {
    return _singleton;
  }

  BluetoothManager._internal();
  final Map <String,dynamic> _device_slot1 = {"device": 0};
  final Map <String,dynamic> _device_slot2 = {"device": 0};

  final List<String> blacklist = [];


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
    await FlutterBluePlus.startScan();

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        // seulement les appareils avec un nom commence par "Polyleaks-"
        if (!r.advertisementData.advName.startsWith("Polyleaks-") && !isInBlacklist(r.advertisementData.advName)){
          continue;
        }
        print("Found device: ${r.advertisementData.advName}");

        if (capteurState.getSlot(1)["state"] == CapteurSlotState.recherche) {
          capteurState.setSlotState(1, state: CapteurSlotState.trouve, nom: r.advertisementData.advName);
          _device_slot1["device"] = r.device;
          print(_device_slot1["device"]);
          await FlutterBluePlus.stopScan();
          return;
        }
        
        else if (capteurState.getSlot(2)["state"] == CapteurSlotState.recherche && capteurState.getSlot(1)["state"] != CapteurSlotState.trouve){
          capteurState.setSlotState(2, state: CapteurSlotState.trouve, nom: r.advertisementData.advName);
          _device_slot2["device"] = r.device;
          await FlutterBluePlus.stopScan();
          return;
        }
      }
    });

}


  void stopScan() async {
    await FlutterBluePlus.stopScan();
  }



  void connectDevice(BuildContext context, slot) async {
    // affecter a device la bonne info 
    var device = slot == 1 ? _device_slot1["device"] : _device_slot2["device"];
    final capteurState = context.read<CapteurStateNotifier>();
    final dataBase = context.read<PolyleaksDatabase>();

    capteurState.setSlotState(slot, state: CapteurSlotState.chargement);


    // connection de device
    try {
      print(device);
      await device.connect();
    }
    catch (e) {
      print("l'appareil n'est plus là.");
      print(e);
      // TODO: afficher une popup pour dire que la connexion a échoué
      return;
    }

    List<BluetoothService> services = await device.discoverServices();
    
    // decouvrire les différentes données du capteur
    var longitude;
    var latitude;
    var nom;
    var date_init;
    var caracteristique_valeur;

    for (BluetoothService service in services) {
      // LOCALISATION
      if (service.uuid.toString() == "1819") {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {

          // LATITUDE
          if (c.properties.read) {
            if (c.uuid.toString() == "2aae") {
              List<int> value = await c.read();
              latitude = value;
            }
          }

          // LONGITUDE
          if (c.properties.read) {
            if (c.uuid.toString() == "2aaf") {
              List<int> value = await c.read();
              longitude = value;
            }
          }
        }
      }

      // INFORMATIONS
      // 0000180a-0000-1000-8000-00805f9b34fb
      if (service.uuid.toString() == "180a") {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {

          // NOM
          if (c.properties.read) {
            if (c.uuid.toString() == "2a00") {
              List<int> value = await c.read();
              nom = value;
            }
          }

          // DATE INIT
          if (c.properties.read) {
            if (c.uuid.toString() == "2a08") {
              List<int> value = await c.read();
              date_init = value;
            }
          }
        }
      }

      // VALEUR
      if (service.uuid.toString() == "44ebee62-6974-412d-a0f7-7363becaca50") {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == "ee0c2084-8786-40ba-ab96-99b91ac981d8") {
            caracteristique_valeur = c;
          }
        }
      }      
    }


    // convertir les exadecimal en string
    var latitudeStr = String.fromCharCodes(latitude);
    var longitudeStr = String.fromCharCodes(longitude);
    var nomStr = String.fromCharCodes(nom);
    var date_initStr = String.fromCharCodes(date_init);

    print("latitude: $latitudeStr");
    print("longitude: $longitudeStr");
    print("nom: $nomStr");
    print("date_init: $date_initStr");
    print(caracteristique_valeur);
    

    // ajouter le capteur a la base de données
    await dataBase.ajouterCapteur(nomStr, DateTime.parse(date_initStr), [double.parse(latitudeStr), double.parse(longitudeStr)]);


    await caracteristique_valeur.setNotifyValue(true);
    
    var subscription = caracteristique_valeur.onValueReceived.listen((value) {
      value = String.fromCharCodes(value);
      // string to int
      value = int.parse(value);
      print("valeur: $value");
      capteurState.setSlotState(slot, valeur: value.toDouble(), derniereConnexion: DateTime.now());
      dataBase.modifierValeurCapteur(nomStr, value.toDouble());
    });

    device.cancelWhenDisconnected(subscription);

    // changer l'etat du slot
    capteurState.setSlotState(slot, state: CapteurSlotState.connecte);
  }



  void disconnectDevice(BuildContext context, slot) async {
    var device = slot == 1 ? _device_slot1["device"] : _device_slot2["device"];
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);

    await device.disconnect();
    capteurState.setSlotState(slot, state: CapteurSlotState.recherche);
  }

  
  void addtoblacklist(BuildContext context, String deviceName) async {
    blacklist.add(deviceName);
  }
  bool isInBlacklist(String deviceName) {
    return blacklist.contains(deviceName);
  }


  void ignorer(BuildContext context, int slot) async {
  // Ajoutez le capteur actuel à la liste noire
  addtoblacklist(context, slot == 1 ? _device_slot1["device"].name : _device_slot2["device"].name);
  scanForDevices(context);

  }
}