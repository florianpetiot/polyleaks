import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';

class BottomSheetDetails extends StatelessWidget {
  final int slot;

  const BottomSheetDetails({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {

    final String NomCapteur = context.read<CapteurStateNotifier>().getSlot(slot)["nom"];
    final double valeurCapteur = context.watch<CapteurStateNotifier>().getSlot(slot)["valeur"];
    final DateTime derniereConnexion = context.watch<CapteurStateNotifier>().getSlot(slot)["derniereConnexion"];
    final DateTime dateInitilalisation = context.watch<CapteurStateNotifier>().getSlot(slot)["dateInitialisation"];
    
    final String derniereConnexionStr = DateFormat('dd/MM/yy HH:mm:ss').format(derniereConnexion);
    final String dateInitilalisationStr = DateFormat('dd/MM/yy HH:mm:ss').format(dateInitilalisation);


    return Wrap(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          child: Column(
            // DETAILS CAPTEUR
            children: [
              Column(
                children: [
                  // Titre
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(NomCapteur,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),

                  const SizedBox(height: 15),

                  // Valeur
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Mesure : ${valeurCapteur}m/s",
                        style: const TextStyle(
                          fontSize: 17,
                        )),
                  ),

                  // Dernière connexion
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Dernière connexion : $derniereConnexionStr",
                        style: const TextStyle(
                          fontSize: 17,
                        )),
                  ),

                  // Date d'initialisation
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Date d'initialisation : $dateInitilalisationStr",
                        style: const TextStyle(
                          fontSize: 17,
                        )),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // CARTE GOOGLE MAPS
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: const Text("Carte Google Maps"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showBottomSheetDetails(BuildContext context, int slot) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BottomSheetDetails(slot: slot,);
    },
  );
}
