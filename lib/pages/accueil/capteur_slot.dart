import 'package:flutter/material.dart';
import 'package:polyleaks/components/carte_capteur_connecte.dart';
import 'package:polyleaks/components/carte_capteur_recherche.dart';
import 'package:polyleaks/components/carte_capteur_trouve.dart';

enum CapteurState { recherche, trouve, connecte }

class CapteurSlot extends StatefulWidget {
  const CapteurSlot({Key? key}) : super(key: key);

  @override
  State<CapteurSlot> createState() => _CapteurSlotState();
}

class _CapteurSlotState extends State<CapteurSlot> {
  CapteurState _state = CapteurState.recherche;

  void setCapteurState(CapteurState state) {
    setState(() {
      _state = state;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case CapteurState.recherche:
        return CarteCapteurRecherche(trouve: () => setCapteurState(CapteurState.trouve));
      case CapteurState.trouve:
        return CarteCapteurTrouve(nomCapteur: 'PolyLeaks-49415', connection: () => setCapteurState(CapteurState.connecte));
      case CapteurState.connecte:
        return CarteCapteurConnecte(nomCapteur: "PolyLeaks-49415", derniereConnexion: DateTime.now(), donnee: 18.2, deconnexion: () => setCapteurState(CapteurState.recherche));
      default:
        return CarteCapteurRecherche(trouve: () => setCapteurState(CapteurState.trouve));
    }
  }
}