import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class BottomSheetDetails extends StatelessWidget {
  final bool vueMaps;
  final bool vueSlot;
  final String? nom;
  final int? slot;
  const BottomSheetDetails({super.key, required this.vueMaps, required this.vueSlot, this.nom, this.slot});

  @override
  Widget build(BuildContext context) {
    String nomCapteur = "";
    double valeurCapteur = 0.0;
    DateTime derniereConnexion = DateTime.now();
    DateTime dateInitilalisation = DateTime.now();
    double latitude = 0.0;
    double longitude = 0.0;
    LatLng center = const LatLng(0, 0);
    String derniereConnexionStr = "";
    String dateInitilalisationStr = "";

    int? localSlot = slot;

    if (nom == context.read<CapteurStateNotifier>().getSlot(1)["nom"]) {
      localSlot = 1;
    }
    if (nom == context.read<CapteurStateNotifier>().getSlot(2)["nom"]) {
      localSlot = 2;
    }

    // si le slot = 1 ou 2
    if (localSlot != null) {
      nomCapteur = context.read<CapteurStateNotifier>().getSlot(localSlot)["nom"];
      valeurCapteur = context.watch<CapteurStateNotifier>().getSlot(localSlot)["valeur"];
      derniereConnexion = context.watch<CapteurStateNotifier>().getSlot(localSlot)["derniereConnexion"];
      dateInitilalisation = context.watch<CapteurStateNotifier>().getSlot(localSlot)["dateInitialisation"];
      latitude = context.read<CapteurStateNotifier>().getSlot(localSlot)["latitude"];
      longitude = context.read<CapteurStateNotifier>().getSlot(localSlot)["longitude"];
      center = LatLng(latitude, longitude);
      derniereConnexionStr = DateFormat('dd/MM/yy HH:mm:ss').format(derniereConnexion);
      dateInitilalisationStr = DateFormat('dd/MM/yy HH:mm:ss').format(dateInitilalisation);

      return BottomSheet(nomCapteur: nomCapteur, valeurCapteur: valeurCapteur, derniereConnexionStr: derniereConnexionStr, dateInitilalisationStr: dateInitilalisationStr, vueMaps: vueMaps, vueSlot: vueSlot, center: center, latitude: latitude, longitude: longitude);

    }

    else if (nom != null) {
      return FutureBuilder<Map<String, dynamic>>(
        future: PolyleaksDatabase().getDetailsCapteur(nom!),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          else {
            Map<String, dynamic> data = snapshot.data!;
            nomCapteur = data["nom"];
            valeurCapteur = data["valeur"];
            derniereConnexion = data["dateDerniereConnexion"];
            dateInitilalisation = data["dateInitialisation"];
            final List<double> localisation = data["localisation"];
            latitude = localisation[0];
            longitude = localisation[1];
            center = LatLng(latitude, longitude);
            derniereConnexionStr = DateFormat('dd/MM/yy HH:mm:ss').format(derniereConnexion);
            dateInitilalisationStr = DateFormat('dd/MM/yy HH:mm:ss').format(dateInitilalisation);
            return BottomSheet(nomCapteur: nomCapteur, valeurCapteur: valeurCapteur, derniereConnexionStr: derniereConnexionStr, dateInitilalisationStr: dateInitilalisationStr, vueMaps: vueMaps, vueSlot: vueSlot, center: center, latitude: latitude, longitude: longitude);
          }
          }
    );
    }
    else {
      throw "Impossible de récupérer les données du capteur";
    }
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
    required this.nomCapteur,
    required this.valeurCapteur,
    required this.derniereConnexionStr,
    required this.dateInitilalisationStr,
    required this.vueMaps,
    required this.vueSlot,
    required this.center,
    required this.latitude,
    required this.longitude,
  });

  final String nomCapteur;
  final double valeurCapteur;
  final String derniereConnexionStr;
  final String dateInitilalisationStr;
  final bool vueMaps;
  final bool vueSlot;
  final LatLng center;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
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
    
                  const SizedBox(height: 5),
    
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
    
              if (vueMaps)
              const SizedBox(height: 25),
    
              if (vueMaps)
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
                        onTap: () async => await launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude")),
                      ),
                    },
                    mapToolbarEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: false,
                    onTap: (LatLng latLng) async {
                      // ouvrir le point dans l'apllication google maps
                      await launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude"));
                    },
                  ),
                ),
              ),
    
              if (!vueMaps)
              // lien hypertexte pour ouvrir google maps
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () async {
                    await launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude"));
                  },
                  child: const Row(
                    children: [
                      Text("Ouvrir dans Google Maps",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue,
                        )),
                      SizedBox(width: 5),
                      Icon(Icons.open_in_new, color: Colors.blue, size: 20),
                    ]
                  ),
                ),
              ),

              if (vueSlot)
              const SizedBox(height: 25),
    
              // ligne de deux containers
              if (vueSlot)
              Row(
                children: [
                  // Container 1
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        // texte centré "mettre dans l'emplacement 1"
                        child: const Text("Mettre dans l'emplacement 1",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
    
                  const SizedBox(width: 15),
    
                  // Container 2
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: const Text("Mettre dans l'emplacement 2",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}


void showBottomSheetDetails(BuildContext context, {required bool vueMaps, required bool vueSlot, String? nom, int? slot}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BottomSheetDetails(vueMaps: vueMaps, vueSlot: vueSlot, nom: nom, slot: slot);
    },
  );
}
