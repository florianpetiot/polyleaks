import 'package:flutter/material.dart';
import 'package:polyleaks/components/point_clignotant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarteCapteurRecherche extends StatelessWidget {
  final int slot;

  const CarteCapteurRecherche({super.key, required this.slot});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: 185,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
      
        // Contenu de la carte ---------------------------------------------------
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const BlinkingDot(),
            Text(
              AppLocalizations.of(context)!.slotRecherche,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
       
      
      ),
    );
  }
}
