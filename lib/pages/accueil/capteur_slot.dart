import 'package:flutter/material.dart';
import 'package:polyleaks/components/carte_capteur_connecte.dart';
import 'package:polyleaks/components/carte_capteur_recherche.dart';
import 'package:polyleaks/components/carte_capteur_trouve.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';


class CapteurSlot extends StatefulWidget {
  final int slot;
  const CapteurSlot({Key? key, required this.slot}) : super(key: key);

  @override
  State<CapteurSlot> createState() => _CapteurSlotState();
}

class _CapteurSlotState extends State<CapteurSlot> {

  @override
  Widget build(BuildContext context) {

    final capteurState = Provider.of<CapteurStateNotifier>(context);

    // utiliser le state du bon slot
    final _state = widget.slot == 1 ? capteurState.slot1State : capteurState.slot2State;
  

    switch (_state) {
      case CapteurSlotState.recherche:
        return CarteCapteurRecherche(slot: widget.slot);

      case CapteurSlotState.trouve:
         return CarteCapteurTrouve(slot: widget.slot, nomCapteur: 'PolyLeaks-49415');

      case CapteurSlotState.connecte:
         return CarteCapteurConnecte(slot: widget.slot, nomCapteur: "PolyLeaks-49415", derniereConnexion: DateTime.now(), donnee: 18.2);
      default:
        return CarteCapteurRecherche(slot: widget.slot,);
    }



    // switch (_state) {
    //   case CapteurState.recherche:
    //     return CarteCapteurRecherche(trouve: () => setCapteurState(CapteurState.trouve));
    //   case CapteurState.trouve:
    //     return CarteCapteurTrouve(nomCapteur: 'PolyLeaks-49415', connexion: () => setCapteurState(CapteurState.connecte));
    //   case CapteurState.connecte:
    //     return CarteCapteurConnecte(nomCapteur: "PolyLeaks-49415", derniereConnexion: DateTime.now(), donnee: 18.2, deconnexion: () => setCapteurState(CapteurState.recherche));
    //   default:
    //     return CarteCapteurRecherche(trouve: () => setCapteurState(CapteurState.trouve));
    // }
  }
}