import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BottomSheetDetails extends StatelessWidget {
  final int slot;

  const BottomSheetDetails({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {

    final String nomCapteur = context.read<CapteurStateNotifier>().getSlot(slot)["nom"];
    final double valeurCapteur = context.watch<CapteurStateNotifier>().getSlot(slot)["valeur"];
    final DateTime derniereConnexion = context.watch<CapteurStateNotifier>().getSlot(slot)["derniereConnexion"];
    final DateTime dateInitilalisation = context.watch<CapteurStateNotifier>().getSlot(slot)["dateInitialisation"];
    final double latitude = context.read<CapteurStateNotifier>().getSlot(slot)["latitude"];
    final double longitude = context.read<CapteurStateNotifier>().getSlot(slot)["longitude"];

    final LatLng center = LatLng(latitude, longitude);
    final String derniereConnexionStr = DateFormat('dd/MM/yy HH:mm:ss').format(derniereConnexion);
    final String dateInitilalisationStr = DateFormat('dd/MM/yy HH:mm:ss').format(dateInitilalisation);


    return Wrap(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 30),
          child: Column(
            children: [
              
              // BARRE DE SEPARATION
              Container(
                height: 7,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(bottom: 15),
              ),

              
              // DETAILS CAPTEUR
              Column(
                children: [
                  // Titre
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(nomCapteur,
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

              const SizedBox(height: 25),

              // CARTE GOOGLE MAPS
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child:  ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: center,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(nomCapteur),
                        position: center,
                      ),
                    },
                    scrollGesturesEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                ),
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
      return BottomSheetDetails(slot: slot);
    },
  );
}
