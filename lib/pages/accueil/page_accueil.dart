import 'package:flutter/material.dart';
import 'package:polyleaks/components/carte_capteur_connecte.dart';
import 'package:polyleaks/components/carte_capteur_recherche.dart';
import 'package:polyleaks/components/carte_capteur_trouve.dart';
import 'package:polyleaks/pages/accueil/capteur_slot.dart';


class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          // Moitié haute de l'écran --------------------------------------------
          Expanded(
            flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // const CarteCapteurTrouve(nomCapteur: 'PolyLeaks-49415'),
              // // CarteCapteurConnecte(nomCapteur: "PolyLeaks-49415", derniereConnexion: DateTime.now(), donnee: 18.2),
              // const CarteCapteurRecherche(),

              CapteurSlot(),
              CapteurSlot()

            ],
          )),
      
          // Moitié basse de l'écran --------------------------------------------
          Expanded(
            flex: 3,
              child: Container(
            
          ))
        ],
      )),
    );
  }
}
