import "package:flutter/material.dart";
import "package:polyleaks/pages/accueil/capteur_slot_provider.dart";
import "package:provider/provider.dart";

class CarteCapteurChargement extends StatelessWidget {
  final int slot;

  const CarteCapteurChargement({Key? key, required this.slot})
      : super(key: key);

  String getNomCapteur(context) {
    final capteurState =
        Provider.of<CapteurStateNotifier>(context, listen: false);
    return capteurState.getSlot(slot)["nom"].toString();
  }

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
          // un point bleu aligné avec un texte au centre vertical de la carte
          // la hauteur de la carte prend toute la hauteur disponible
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      // recuperer le nom depuis le provider
                      getNomCapteur(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // chargement
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ]),
        ));
  }
}
