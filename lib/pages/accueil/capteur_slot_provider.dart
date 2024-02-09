import 'package:flutter/material.dart';

enum CapteurSlotState { recherche, trouve, connecte, perdu}



class CapteurStateNotifier extends ChangeNotifier {
  final Map<String,dynamic> _slot1 = { "state": CapteurSlotState.recherche, "valeur": 18.5, "nom":0,"derniereConnexion":""};
  final Map<String,dynamic> _slot2 = { "state": CapteurSlotState.recherche, "valeur": 15.2, "nom":0,"derniereConnexion":""};



  Map<String, dynamic> getSlot(int id) {
    if (id == 1) {
      return _slot1;
    } else {
      return _slot2;
    }
  }


  // faire une seule fonction pour modifier slot1 ou slot2 avec un arguement obligatoire pour choisir le slot
  // et les autres arguments optionnels pour modifier les valeurs
  void setSlotState(int slot, {CapteurSlotState? state, double? valeur, String? nom, String? derniereConnexion}) {
    Map<String, dynamic> targetSlot = slot == 1 ? _slot1 : _slot2;

    if (state != null) {
      targetSlot.update("state", (existing) => state);
    }
    if (valeur != null) {
      targetSlot.update("valeur", (existing) => valeur);
    }
    if (nom != null) {
      targetSlot.update("nom", (existing) => nom);
    }
    if (derniereConnexion != null) {
      targetSlot.update("derniereConnexion", (existing) => derniereConnexion);
    }

    notifyListeners();
  }
}
