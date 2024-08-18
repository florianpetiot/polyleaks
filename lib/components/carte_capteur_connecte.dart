import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/components/bottom_sheet_details.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class CarteCapteurConnecte extends StatelessWidget {
  final int slot;

  const CarteCapteurConnecte(
      {super.key,
      required this.slot,});



  void setCapteurState(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    capteurState.setSlotState(slot, state: CapteurSlotState.recherche);
  }

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
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.slotConnecte1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ]),

            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.watch<CapteurStateNotifier>().getSlot(slot)["valeur"].toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'L/h',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // bouton se connecter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => showBottomSheetDetails(context, vueMaps: true, vueSlot: false, slot: slot),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.slotConnecte2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),

                  ElevatedButton(
                      onPressed: () => BluetoothManager().disconnectDevice(context, slot),
                      style: ElevatedButton.styleFrom(                        
                        minimumSize: const Size(55,40),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        backgroundColor: const Color(0xFF8A8A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.highlight_off, color: Colors.white)
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
