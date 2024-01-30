import 'package:flutter/material.dart';
import 'package:polyleaks/components/point_clignotant.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class CarteCapteurRecherche extends StatelessWidget {
  final int slot;

  const CarteCapteurRecherche({super.key, required this.slot});


  void setCapteurState(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    if (slot == 1) {
      capteurState.setSlot1State(CapteurSlotState.trouve);
    } else {
      capteurState.setSlot2State(CapteurSlotState.trouve);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => setCapteurState(context),
        child: Container(
          width: 185,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFB7B7B7),
              width: 1,
            ),
          ),
        
          // Contenu de la carte ---------------------------------------------------
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlinkingDot(),
              Text(
                'Recherche...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
         
        
        ),
      ),
    );
  }
}
