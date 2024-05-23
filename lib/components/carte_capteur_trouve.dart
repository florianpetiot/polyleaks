import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class CarteCapteurTrouve extends StatelessWidget {
  final int slot;

  const CarteCapteurTrouve({Key? key, required this.slot}) : super(key: key);

  String getNomCapteur(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    return capteurState.getSlot(slot)["nom"];
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
            Column(children: [
                Text(
                  // recuperer le nom depuis le provider
                  getNomCapteur(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.slotTrouve1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),
          
            // bouton se connecter
            Column(
              children: [
                ElevatedButton(
                    onPressed: () => BluetoothManager().connectDevice(context, slot),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A8A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.slotTrouve2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )
                ),

                const SizedBox(height: 10),

                Material (
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => BluetoothManager().ignorer(context,slot),
                    child: Text(
                      AppLocalizations.of(context)!.slotTrouve3,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
            ],
        ),
      ),
    );
  }
}
