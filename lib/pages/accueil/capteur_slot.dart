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
    final state = capteurState.getSlot(widget.slot)["state"]; 
  

    switch (state) {
      case CapteurSlotState.recherche:
        return CarteCapteurRecherche(slot: widget.slot);

      case CapteurSlotState.trouve:
         return CarteCapteurTrouve(slot: widget.slot);

      case CapteurSlotState.connecte:
         return CarteCapteurConnecte(slot: widget.slot);
      default:
        return CarteCapteurRecherche(slot: widget.slot);
    }

  }
}