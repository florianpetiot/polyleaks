import 'package:flutter/material.dart';
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
          const Expanded(
            flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CapteurSlot(slot: 1,),
              CapteurSlot(slot: 2,)
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
