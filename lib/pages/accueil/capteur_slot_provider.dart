import 'package:flutter/material.dart';

enum CapteurSlotState {recherche, chargement, trouve, connecte, perdu}



class CapteurStateNotifier extends ChangeNotifier {
  final Map<String,dynamic> _slot1 = { "state": CapteurSlotState.recherche, "valeur": 0.0, "nom":0,"derniereConnexion":0, "dateInitialisation":0, "latitude":0, "longitude":0};
  final Map<String,dynamic> _slot2 = { "state": CapteurSlotState.recherche, "valeur": 0.0, "nom":0,"derniereConnexion":0, "dateInitialisation":0, "latitude":0, "longitude":0};
  final List<String> _blacklist = [];
  bool _gpsPermission = true;
  bool _bluetoothPermission = true;


  bool get bluetoothPermission => _bluetoothPermission;

  void setBluetoothPermission(bool permission) {
    _bluetoothPermission = permission;
    notifyListeners();
  }

  bool get gpsPermission => _gpsPermission;

  void setGpsPermission(bool permission) {
    _gpsPermission = permission;
    notifyListeners();
  }


  get blacklist => _blacklist;

  void addToBlacklist(String nom) {
    _blacklist.add(nom);
    notifyListeners();
  }

  void resetBlacklist() {
    print("resetting blacklist");
    _blacklist.clear();
    notifyListeners();
  }


  Map<String, dynamic> getSlot(int id) {
    if (id == 1) {
      return _slot1;
    } else {
      return _slot2;
    }
  }


  // faire une seule fonction pour modifier slot1 ou slot2 avec un arguement obligatoire pour choisir le slot
  // et les autres arguments optionnels pour modifier les valeurs...
  void setSlotState(int slot, {CapteurSlotState? state, double? valeur, String? nom, DateTime? derniereConnexion, DateTime? dateInitialisation, double? latitude, double? longitude}) {
    Map<String, dynamic> targetSlot = slot == 1 ? _slot1 : _slot2;

    if (state != null) {
      targetSlot["state"] = state;
    }
    if (valeur != null) {
      targetSlot["valeur"] = valeur;
    }
    if (nom != null) {
      targetSlot["nom"] = nom;
    }
    if (derniereConnexion != null) {
      targetSlot["derniereConnexion"] = derniereConnexion;
    }
    if (dateInitialisation != null) {
      targetSlot["dateInitialisation"] = dateInitialisation;
    }
    if (latitude != null) {
      targetSlot["latitude"] = latitude;
    }
    if (longitude != null) {
      targetSlot["longitude"] = longitude;
    }

    notifyListeners();
  }
  
  
}

