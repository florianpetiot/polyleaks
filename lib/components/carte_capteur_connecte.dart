import 'package:flutter/material.dart';
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
  
  void setCapteurStateToPerdu(context){
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    capteurState.setSlotState(slot, state: CapteurSlotState.perdu);
  }

  String getNomCapteur(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    return capteurState.getSlot(slot)["nom"];
  }

  double getValeurCapteur(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context);
    return capteurState.getSlot(slot)["valeur"];
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
        // un point bleu aligné avec un texte au centre vertical de la carte
        // la hauteur de la carte prend toute la hauteur disponible
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              GestureDetector(
                onTap: () => setCapteurStateToPerdu(context),
                child: Text(
                  // recuperer le nom depuis le provider
                  getNomCapteur(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                  const Text(
                    'Maintenant',
                    style: TextStyle(
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
                  getValeurCapteur(context).toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'm/s',
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Détails',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),

                  ElevatedButton(
                      onPressed: () => setCapteurState(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.cancel, color: Colors.white)
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
