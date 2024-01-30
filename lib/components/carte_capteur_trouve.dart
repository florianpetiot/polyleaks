import 'package:flutter/material.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class CarteCapteurTrouve extends StatelessWidget {
  final int slot;
  final String nomCapteur;

  const CarteCapteurTrouve({Key? key, required this.slot, required this.nomCapteur}) : super(key: key);


   void setCapteurState(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    if (slot == 1) {
      capteurState.setSlot1State(CapteurSlotState.connecte);
    } else {
      capteurState.setSlot2State(CapteurSlotState.connecte);
    }
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
                Text(
                  nomCapteur,
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
                    const Text(
                      'Trouvé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),
          
            // bouton se connecter
            ElevatedButton(
                onPressed: () => setCapteurState(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A8A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
