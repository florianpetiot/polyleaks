import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/main.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';
import 'package:polyleaks/components/popup_erreur.dart';
import 'package:toastification/toastification.dart';

class BluetoothManager {
  static final BluetoothManager _singleton = BluetoothManager._internal();

  factory BluetoothManager() {
    return _singleton;
  }

  BluetoothManager._internal();
  final Map <String,dynamic> _device_slot1 = {"device": 0};
  final Map <String,dynamic> _device_slot2 = {"device": 0};
  List<bool> deconnexionVoulue = [false, false];
  bool isScaning = false;
  var scanResult;


  // ---------------------------------------------------------------------------
  // -------------------- GESTION DES PERMISSIONS ------------------------------
  // ---------------------------------------------------------------------------
  // MARK: - PERMISSIONS
  

  Future<bool?> isBluetoothActivated(context) async {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    
    // verifier si le bluetooth est désactivé
    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {

      // ios - on ne peut pas activer le bluetooth depuis l'application
      if (defaultTargetPlatform != TargetPlatform.android) {
        await showDialog(
          context: context, 
          builder: (context) => const PopupErreur(idErreur: 5)
        );
        capteurState.setBluetoothPermission(false);
        return null;
      }

      // android - on tente d'activer le bluetooth
      else {
        for (int i = 0; i < 2; i++) {
          try {
            await FlutterBluePlus.turnOn();
            capteurState.setBluetoothPermission(true);
            return true;
          }
          catch (e) {
            if (i == 0) {
              await showDialog(
                context: context, 
                builder: (context) => const PopupErreur(idErreur: 5)
              );
            }
            else {
              capteurState.setBluetoothPermission(false);
              return false;
            }
          }
        }
      } 
    }
    else {
      capteurState.setBluetoothPermission(true);
      return true;
    }
    capteurState.setBluetoothPermission(false);
    return false;
  }


  Future<bool?> isLocationActivated(context, {bool? maps}) async {
  
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);

    // seul les android on besoin de la permission de localisation pour le scan bluetooth
    // les ios ont besoin de la permission pour les cartes
    if (defaultTargetPlatform != TargetPlatform.android && maps != true) {
      capteurState.setGpsPermission(true);
      return true;
    }

    // pour la localisation on a besoin de s'assuerer de la permission avant de regarder si le GPS est activé

    // GESTION PERMISSION --------------------------------------------------------------
    LocationPermission permissionStatus = await Geolocator.checkPermission();

    for (int i = 0; i < 2; i++) {
      if (permissionStatus == LocationPermission.denied) {
        if (await Geolocator.requestPermission() != LocationPermission.deniedForever) {
          permissionStatus = await Geolocator.checkPermission(); 
        }
        else {
          permissionStatus = LocationPermission.deniedForever;
        }

        if (permissionStatus == LocationPermission.denied && i == 0) {
          await showDialog(
            context: context, 
            builder: (context) => const PopupErreur(idErreur: 3)
          );
        } 
        else {
          break;
        }
      }
    }

    if (permissionStatus == LocationPermission.deniedForever) {
      await showDialog(
        context: context, 
        builder: (context) => const PopupErreur(idErreur: 4)
      );
      capteurState.setGpsPermission(false);
      return null;
    }

    if (permissionStatus == LocationPermission.denied) {
      capteurState.setGpsPermission(false);
      return false;
    }

    // GESTION DE L'ACTIVATION DU GPS --------------------------------------------------
    if (!(await Geolocator.isLocationServiceEnabled())) {
      try {
        await Geolocator.getCurrentPosition();
        capteurState.setGpsPermission(true);
        return true;
      } 
      catch (e) {
        capteurState.setGpsPermission(false);
        return false;
      }
    }
    else {
      capteurState.setGpsPermission(true);
      return true;
    }
  }


  // ---------------------------------------------------------------------------
  // -------------------- FONCTIONS GLOBALES -----------------------------------
  // ---------------------------------------------------------------------------
  // MARK: - GLOBALES

  void stopScan() async {
    if (scanResult != null) {
      FlutterBluePlus.cancelWhenScanComplete(scanResult);
    }
    await FlutterBluePlus.stopScan();
    isScaning = false;
    return;
  }

  
  // ---------------------------------------------------------------------------
  // -------------------- PARTIE ECRAN ACCUEIL ---------------------------------
  // ---------------------------------------------------------------------------
  // MARK: - ECRAN ACCUEIL

  void scanForDevices(BuildContext context) async {

    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    final blacklist = capteurState.blacklist;

    // verifier si les cartes sont en mode recherche
    if (!([CapteurSlotState.recherche, CapteurSlotState.perdu].contains(capteurState.getSlot(1)["state"]) || [CapteurSlotState.recherche, CapteurSlotState.perdu].contains(capteurState.getSlot(2)["state"]))) {
      print("No slot in recherche mode");
      return;
    }

    // verifier si un scan est deja en cours
    if (isScaning) {
      print("Already scanning");
      return;
    }

    // verifier si le bluetooth est supporté
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }
    
    // gestion des demandes de permission pour le GPS --------------------------------
    if (capteurState.gpsPermission == false) {
      print("Location not activated");
      return;
    }

    if (await isLocationActivated(context) == false) {
      print("Location not activated");
      return;
    }

    // gestion des demande de permission pour le bluetooth ----------------------------
    if (capteurState.bluetoothPermission == false) {
      print("Bluetooth not activated");
      return;
    }

    if (await isBluetoothActivated(context) == false) {
      print("Bluetooth not activated");
      return;
    }

    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    await FlutterBluePlus.startScan();
    isScaning = true;

    scanResult = FlutterBluePlus.onScanResults.listen((results) async {
      for (ScanResult r in results) {
        // seulement les appareils avec un nom commence par "Polyleaks-"
        if (!r.advertisementData.advName.startsWith("Polyleaks-") || blacklist.contains(r.advertisementData.advName)){
          continue;
        }

        print("Found device: ${r.advertisementData.advName}");

        // si le slot 1 est en mode perdu et que le nom du capteur est le meme que celui du slot 1
        if (capteurState.getSlot(1)["state"] == CapteurSlotState.perdu && capteurState.getSlot(1)["nom"] == r.advertisementData.advName){
          _device_slot1["device"] = r.device;
          connectDevice(context, 1);
        }

        // sinon si le slot 2 est en mode perdu et que le nom du capteur est le meme que celui du slot 2
        else if (capteurState.getSlot(2)["state"] == CapteurSlotState.perdu && capteurState.getSlot(2)["nom"] == r.advertisementData.advName){
          _device_slot2["device"] = r.device;
          connectDevice(context, 2);
        }

        // sinon si le slot 1 est en mode recherche
        else if (capteurState.getSlot(1)["state"] == CapteurSlotState.recherche){
          if (!(([CapteurSlotState.trouve, CapteurSlotState.chargement, CapteurSlotState.connecte, CapteurSlotState.perdu].contains(capteurState.getSlot(2)["state"])) && capteurState.getSlot(2)["nom"] == r.advertisementData.advName)) {
            capteurState.setSlotState(1, state: CapteurSlotState.trouve, nom: r.advertisementData.advName);
            _device_slot1["device"] = r.device;
          }
        }

        // sinon si le slot 2 est en mode recherche
        else if (capteurState.getSlot(2)["state"] == CapteurSlotState.recherche){
          if (!(([CapteurSlotState.trouve, CapteurSlotState.chargement, CapteurSlotState.connecte, CapteurSlotState.perdu].contains(capteurState.getSlot(1)["state"])) && capteurState.getSlot(1)["nom"] == r.advertisementData.advName)) {
            capteurState.setSlotState(2, state: CapteurSlotState.trouve, nom: r.advertisementData.advName);
            _device_slot2["device"] = r.device;
          }
        }

        // verifier si on peut arreter le scan
        if (!([CapteurSlotState.recherche, CapteurSlotState.perdu].contains(capteurState.getSlot(1)["state"]) || [CapteurSlotState.recherche, CapteurSlotState.perdu].contains(capteurState.getSlot(2)["state"]))) {
          await FlutterBluePlus.stopScan();
          isScaning = false;
          return;
        }
      }
    });
    
    FlutterBluePlus.cancelWhenScanComplete(scanResult);
  }


  void connectDevice(BuildContext context, slot) async {
    // affecter a device la bonne info 
    BluetoothDevice device = slot == 1 ? _device_slot1["device"] : _device_slot2["device"];
    deconnexionVoulue[slot-1] = false;
    final capteurState = context.read<CapteurStateNotifier>();
    final dataBase = context.read<PolyleaksDatabase>();

    capteurState.setSlotState(slot, state: CapteurSlotState.chargement);

    // stop scan
    FlutterBluePlus.stopScan();
    isScaning = false;

    // connection de device
    try {
      print(device);
      await device.connect(timeout: const Duration(seconds: 15));
    }
    catch (e) {
      print("l'appareil n'est plus là.");
      print(e);
      await showDialog(
        context: navigatorKey.currentState!.context, 
        builder: (context) => const PopupErreur(idErreur: 1)
      );
      capteurState.setSlotState(slot, state: CapteurSlotState.recherche);
      scanForDevices(navigatorKey.currentState!.context);
      return;
    }

    List<BluetoothService> services = await device.discoverServices();
    
    // decouvrire les différentes données du capteur
    var longitude;
    var latitude;
    var nom;
    var batterie;
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

          // BATTERIE
          if (c.properties.read) {
            if (c.uuid.toString() == "2a19") {
              List<int> value = await c.read();
              batterie = value;
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
    var batterieStr = String.fromCharCodes(batterie);
    var date_initStr = String.fromCharCodes(date_init);

    print("latitude: $latitudeStr");
    print("longitude: $longitudeStr");
    print("nom: $nomStr");
    print("batterie: $batterieStr");
    print("date_init: $date_initStr");
    print(caracteristique_valeur);
    
    // verifier si le capteur est bien initialisé
    // c'est a dire si la latitude et la longitude et date d'initialisation non-vide
    if (latitudeStr.isEmpty || longitudeStr.isEmpty || date_initStr.isEmpty) {
      // disconnect
      await device.disconnect();
      await showDialog(
        context: navigatorKey.currentState!.context, 
        builder: (context) => const PopupErreur(idErreur: 2)
      );
      capteurState.setSlotState(slot, state: CapteurSlotState.recherche);
      scanForDevices(navigatorKey.currentState!.context);
      return;
    }

    // ajouter le capteur a la base de données
    await dataBase.ajouterCapteur(nomStr, int.parse(batterieStr) , DateTime.parse(date_initStr), [double.parse(latitudeStr), double.parse(longitudeStr)]);


    await caracteristique_valeur.setNotifyValue(true);
    
    var abonnementValeur = caracteristique_valeur.onValueReceived.listen((value) {
      value = String.fromCharCodes(value);
      // string to int
      value = double.parse(value);
      print("valeur: $value");
      capteurState.setSlotState(slot, valeur: value.toDouble(), derniereConnexion: DateTime.now());
    });

    device.cancelWhenDisconnected(abonnementValeur);

    // changer l'etat du slot
    capteurState.setSlotState(slot, 
                    state: CapteurSlotState.connecte, 
                    derniereConnexion: DateTime.now(), 
                    batterie: int.parse(batterieStr),
                    dateInitialisation: DateTime.parse(date_initStr),
                    latitude: double.parse(latitudeStr),
                    longitude: double.parse(longitudeStr));

    // reprendre le scan
    scanForDevices(navigatorKey.currentState!.context);

    // on disconnect
    var deconnexion = device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
            // sauvegarder les données dans la base de données
            print("Le capteur est deconnecté");
            var deviceData = capteurState.getSlot(slot);
            await dataBase.modifierValeurCapteur(deviceData["nom"], deviceData["valeur"], deviceData["batterie"]);
            if (!deconnexionVoulue[slot-1]){
              capteurState.setSlotState(slot, state: CapteurSlotState.perdu);
              scanForDevices(navigatorKey.currentState!.context);
            }
        }
    });

    device.cancelWhenDisconnected(deconnexion, delayed:true, next:true);

  }


  void disconnectDevice(BuildContext context, slot) async {
    var device = slot == 1 ? _device_slot1["device"] : _device_slot2["device"];
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);

    deconnexionVoulue[slot-1] = true;
    await device.disconnect();
    capteurState.setSlotState(slot, state: CapteurSlotState.recherche);
    scanForDevices(navigatorKey.currentState!.context);
  }


  void resetBlacklist(BuildContext context) async {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    await FlutterBluePlus.stopScan();
    isScaning = false;
    capteurState.resetBlacklist();
    scanForDevices(context);
  }


  void ignorer(BuildContext context, int slot) async {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);

    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      icon: const Icon(Icons.info, color: Colors.white),
      title: Text('${slot == 1 ? _device_slot1["device"].name : _device_slot2["device"].name} à été ajouté à la liste noire temporaire.'),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 7),
      boxShadow: lowModeShadow,
      closeButtonShowType: CloseButtonShowType.none,
      closeOnClick: false,
      dragToClose: true,
      showProgressBar: false,
    );

   
    // Ajoutez le capteur actuel à la liste noire
    capteurState.addToBlacklist(slot == 1 ? _device_slot1["device"].name : _device_slot2["device"].name);
    capteurState.setSlotState(slot, state: CapteurSlotState.recherche);
    scanForDevices(navigatorKey.currentState!.context);

  }


  // ---------------------------------------------------------------------------
  // -------------------- PARTIE INITIALISATION --------------------------------
  // ---------------------------------------------------------------------------
  // MARK: - INITIALISATION

  Future<Stream<List<ScanResult>>> getScanList(BuildContext context, index) async {

    // verifier si le bluetooth est supporté
    if (await FlutterBluePlus.isSupported == false || index != 2) {
      return Stream.error("error");
    }

    if (await isLocationActivated(context) == false) {
      return Stream.error("error");
    }

    if (await isBluetoothActivated(context) == false) {
      return Stream.error("error");
    }

    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    await FlutterBluePlus.startScan();
    isScaning = true;

    return FlutterBluePlus.onScanResults;
  }


  Future<List<bool>> transmissionPosition(BluetoothDevice device, Position position) async {

    List<bool> resultat = [true, true];

     // connection de device
    try {
      await device.connect(timeout: const Duration(seconds: 15));
    }
    catch (e) {
      resultat[0] = false;
      return resultat;
    }

    List<BluetoothService> services = await device.discoverServices();

    // verifier que le service de geolocalisation est pas deja rempli

    for (BluetoothService service in services) {

      // LOCALISATION
      if (service.uuid.toString() == "1819") {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {

          // LATITUDE
          if (c.properties.read) {
            if (c.uuid.toString() == "2aae") {
              List<int> value = await c.read();
              if (value.isNotEmpty) {
                resultat[1] = false;
                await device.disconnect(queue: false);
                return resultat;
              }
            }
          }

          // LONGITUDE
          if (c.properties.read) {
            if (c.uuid.toString() == "2aaf") {
              List<int> value = await c.read();
              if (value.isNotEmpty) {
                resultat[1] = false;
                await device.disconnect(queue: false);
                return resultat;
              }
            }
          }
        }
        break;
      }
    }

    // envoyer la position et donner la date d'initialisation
    var latitude = position.latitude.toString().codeUnits;
    var longitude = position.longitude.toString().codeUnits;

    print("CAPTEUR NON INITIALISE - ENVOI DE LA POSITION");

    for (BluetoothService service in services) {

      // LOCALISATION
      if (service.uuid.toString() == "1819") {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {

          // LATITUDE
          if (c.properties.write) {
            if (c.uuid.toString() == "2aae") {
              print("ECRITURE LATITUDE");
              await c.write(latitude);
            }
          }

          // LONGITUDE
          if (c.properties.write) {
            if (c.uuid.toString() == "2aaf") {
              print("ECRITURE LONGITUDE");
              await c.write(longitude);
            }
          }
        }
      }

      // INFORMATION
      // 0000180a-0000-1000-8000-00805f9b34fb
      if (service.uuid.toString() == "180a") {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {

          // DATE INIT
          if (c.properties.write) {
            if (c.uuid.toString() == "2a08") {
              var date = DateTime.now().toString().codeUnits;
              await c.write(date);
            }
          }
        }
      }
    }

    await device.disconnect();
    return resultat;

  }

}