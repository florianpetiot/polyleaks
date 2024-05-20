import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:popover/popover.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';


void showBottomSheetDetails(BuildContext context, {required bool vueMaps, required bool vueSlot, String? nom, int? slot}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BottomSheetDetails(vueMaps: vueMaps, vueSlot: vueSlot, nom: nom, slot: slot);
    },
  );
}


class BottomSheetDetails extends StatefulWidget {
  final bool vueMaps;
  final bool vueSlot;
  final String? nom;
  final int? slot;
  const BottomSheetDetails({super.key, required this.vueMaps, required this.vueSlot, this.nom, this.slot});

  @override
  State<BottomSheetDetails> createState() => _BottomSheetDetailsState();
}

class _BottomSheetDetailsState extends State<BottomSheetDetails> {
  Future<Map<String, dynamic>>? detailsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.nom != null) {
      detailsFuture = PolyleaksDatabase().getDetailsCapteur(widget.nom!);
    }
  }

  @override
  Widget build(BuildContext context) {
    String nomCapteur = "";
    double valeurCapteur = 0.0;
    int batterieCapteur = 0;
    DateTime derniereConnexion = DateTime.now();
    DateTime dateInitilalisation = DateTime.now();
    double latitude = 0.0;
    double longitude = 0.0;
    LatLng center = const LatLng(0, 0);
    String derniereConnexionStr = "";
    String dateInitilalisationStr = "";

    int? localSlot = widget.slot;

    if (widget.nom == context.read<CapteurStateNotifier>().getSlot(1)["nom"] && context.read<CapteurStateNotifier>().getSlot(1)["state"] == CapteurSlotState.connecte) {
      localSlot = 1;
    }
    if (widget.nom == context.read<CapteurStateNotifier>().getSlot(2)["nom"] && context.read<CapteurStateNotifier>().getSlot(2)["state"] == CapteurSlotState.connecte) {
      localSlot = 2;
    }

    // si le slot = 1 ou 2
    if (localSlot != null) {
      nomCapteur = context.read<CapteurStateNotifier>().getSlot(localSlot)["nom"];
      valeurCapteur = context.watch<CapteurStateNotifier>().getSlot(localSlot)["valeur"];
      batterieCapteur = context.read<CapteurStateNotifier>().getSlot(localSlot)["batterie"];
      derniereConnexion = context.watch<CapteurStateNotifier>().getSlot(localSlot)["derniereConnexion"];
      dateInitilalisation = context.watch<CapteurStateNotifier>().getSlot(localSlot)["dateInitialisation"];
      latitude = context.read<CapteurStateNotifier>().getSlot(localSlot)["latitude"];
      longitude = context.read<CapteurStateNotifier>().getSlot(localSlot)["longitude"];
      center = LatLng(latitude, longitude);
      derniereConnexionStr = DateFormat('dd/MM/yy HH:mm:ss').format(derniereConnexion);
      dateInitilalisationStr = DateFormat('dd/MM/yy HH:mm:ss').format(dateInitilalisation);

      // calcul du pourcentage réel de la batterie, estimé par rapport à la date de la dernière connexion
      // consomation capteur = 37.9mA
      // capacité batterie = 1 660 020 mAh
      int nouvelleBatterie = (batterieCapteur - ((DateTime.now().difference(derniereConnexion).inHours * 37.9) / 1660020) * 100).round();

      int heuresRestantes = ((nouvelleBatterie*1660020)/(37.9*100)).round();

      return BottomSheet(nomCapteur: nomCapteur, valeurCapteur: valeurCapteur,  batterieCapteur: nouvelleBatterie, heuresRestantes: heuresRestantes, derniereConnexionStr: derniereConnexionStr, dateInitilalisationStr: dateInitilalisationStr, vueMaps: widget.vueMaps, vueSlot: widget.vueSlot, center: center, latitude: latitude, longitude: longitude);

    }

    else if (widget.nom != null) {
      return FutureBuilder<Map<String, dynamic>>(
        future: detailsFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          else {
            Map<String, dynamic> data = snapshot.data!;
            nomCapteur = data["nom"];
            valeurCapteur = data["valeur"];
            batterieCapteur = data["batterie"];
            derniereConnexion = data["dateDerniereConnexion"];
            dateInitilalisation = data["dateInitialisation"];
            final List<double> localisation = data["localisation"];
            latitude = localisation[0];
            longitude = localisation[1];
            center = LatLng(latitude, longitude);
            derniereConnexionStr = DateFormat('dd/MM/yy HH:mm:ss').format(derniereConnexion);
            dateInitilalisationStr = DateFormat('dd/MM/yy HH:mm:ss').format(dateInitilalisation);

            // calcul du pourcentage réel de la batterie, estimé par rapport à la date de la dernière connexion
            // consomation capteur = 37.9mA
            // capacité batterie = 1 660 020 mAh
            int nouvelleBatterie = (batterieCapteur - ((DateTime.now().difference(derniereConnexion).inHours * 37.9) / 1660020) * 100).round();

            int heuresRestantes = ((nouvelleBatterie*1660020)/(37.9*100)).round();

            return BottomSheet(nomCapteur: nomCapteur, valeurCapteur: valeurCapteur, batterieCapteur: nouvelleBatterie, heuresRestantes: heuresRestantes, derniereConnexionStr: derniereConnexionStr, dateInitilalisationStr: dateInitilalisationStr, vueMaps: widget.vueMaps, vueSlot: widget.vueSlot, center: center, latitude: latitude, longitude: longitude);
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
    required this.batterieCapteur,
    required this.heuresRestantes,
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
  final int batterieCapteur;
  final int heuresRestantes;
  final String derniereConnexionStr;
  final String dateInitilalisationStr;
  final bool vueMaps;
  final bool vueSlot;
  final LatLng center;
  final double latitude;
  final double longitude;



  void modifierSlot(BuildContext context, int slot) {
    final capteurState = context.read<CapteurStateNotifier>(); 

    // si le slot est connecté
      // deconnecter le capteur
    if (capteurState.getSlot(slot)["state"] == CapteurSlotState.connecte) {
      BluetoothManager().disconnectDevice(context, slot);
    }
    

    // si le slot est perdu
      // mettre en mode recherche

    else if (capteurState.getSlot(slot)["state"] == CapteurSlotState.perdu) {
      capteurState.setSlotState(slot, state: CapteurSlotState.recherche, nom: "");
    }

    // si le slot est vide
      // mettre en mode perdu
    else if (capteurState.getSlot(slot)["state"] == CapteurSlotState.recherche || capteurState.getSlot(slot)["state"] == CapteurSlotState.trouve){
      final dateFormat = DateFormat('dd/MM/yy HH:mm:ss');
      final dateFormatCible = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
      final dateInitilalisationStrCible = dateFormatCible.format(dateFormat.parse(dateInitilalisationStr));
      final derniereConnexionStrCible = dateFormatCible.format(dateFormat.parse(derniereConnexionStr));

      capteurState.setSlotState(slot, 
      state: CapteurSlotState.perdu, 
      nom: nomCapteur, 
      valeur: valeurCapteur, 
      derniereConnexion: DateTime.parse(derniereConnexionStrCible),
      dateInitialisation: DateTime.parse(dateInitilalisationStrCible),
      latitude: latitude,
      longitude: longitude
      );


      // si le capteur était déjà dans l'autre slot
      // rappeller la fonction pour le retirer
      if (capteurState.getSlot(slot == 1 ? 2 : 1)["nom"] == nomCapteur) {
        modifierSlot(context, slot == 1 ? 2 : 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final List<Map<String, dynamic>> etatSlots = [context.watch<CapteurStateNotifier>().getSlot(1), context.watch<CapteurStateNotifier>().getSlot(2)];

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "$nomCapteur  • ",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                        BatteryLevel(batterieCapteur: batterieCapteur, heuresRestantes: heuresRestantes),
                    ],
                  ),
                  
    
                  const SizedBox(height: 5),
    
                  // Valeur
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${AppLocalizations.of(context)!.bs1} : ${valeurCapteur}L/h",
                        style: const TextStyle(
                          fontSize: 17,
                        )),
                  ),
    
                  // Dernière connexion
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${AppLocalizations.of(context)!.bs2} : $derniereConnexionStr",
                        style: const TextStyle(
                          fontSize: 17,
                        )),
                  ),
    
                  // Date d'initialisation
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${AppLocalizations.of(context)!.bs3} : $dateInitilalisationStr",
                        style: const TextStyle(
                          fontSize: 17,
                        )),
                  ),
                ],
              ),
    
              if (vueMaps)
              const SizedBox(height: 15),
    
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
                    onMapCreated: (controller) async {
                      if (Theme.of(context).brightness == Brightness.dark) {
                        // asstes/map_styles/maps_dark_markers.json
                        controller.setMapStyle(await  rootBundle.loadString('assets/map_styles/map_dark_markers.json'));
                      }
                    },
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
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.bs4,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.blue,
                          )),
                        const SizedBox(width: 5),
                        const Icon(Icons.open_in_new, color: Colors.blue, size: 20),
                      ]
                    ),
                  ),
                ),
              ),


              // -------------------------
              // VISIALISATION DES EMPLACEMENT 
              // -------------------------

              if (vueSlot)
              const SizedBox(height: 20),

              // ajout d'une phrase "vue des emplacements" suivit d'une ligne grise jusqu'à la fin de la ligne
              if (vueSlot)
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.bs5,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    )),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ),
                ],
              ),

              if (vueSlot)
              const SizedBox(height: 10),
    
              // ligne de deux containers
              if (vueSlot)
              Row(
                children: List<Widget>.generate(2, (index) =>

                  // si le slot est occupé
                  etatSlots[index]["state"] == CapteurSlotState.connecte || etatSlots[index]["state"] == CapteurSlotState.perdu 
                  ? Expanded(
                    child: GestureDetector(
                      onTap: () => modifierSlot(context, index + 1),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(10),
                        ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.highlight_off, size: 17,),

                              Text(etatSlots[index]["nom"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                height: 1.1,
                              )
                            ),
                            ]
                        
                        ),
                      ),
                    ),
                  )
        
                  // si le slot est vide
                  : Expanded(
                    child: GestureDetector(
                      onTap: () => modifierSlot(context, index + 1),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD6D6D6), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("${AppLocalizations.of(context)!.bs6} ${index + 1}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              height: 1.1,
                            )
                          ),
                        ),
                      ),
                    ),
                  )

                )..insert(1, const SizedBox(width: 15)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class BatteryLevel extends StatelessWidget {
  const BatteryLevel ({super.key, required this.batterieCapteur, required this.heuresRestantes});

  final int batterieCapteur;
  final int heuresRestantes;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showPopover(context: context, 
        bodyBuilder: ((context) {
          return Container(
            color: Theme.of(context).colorScheme.primary,
            width: 270,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    heuresRestantes/(24*365) > 1
                    ? AppLocalizations.of(context)!.bs7annee(heuresRestantes~/(24*365)+1)
                    : heuresRestantes/(24*30) > 1
                    ? AppLocalizations.of(context)!.bs7mois(heuresRestantes~/(24*30))
                    : heuresRestantes/(24) > 1
                    ? AppLocalizations.of(context)!.bs7jour(heuresRestantes~/(24))
                    : AppLocalizations.of(context)!.bs7heure(heuresRestantes),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                    )
                  ),
              
                  const SizedBox(height: 10),
              
                  Text(AppLocalizations.of(context)!.bs8,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.1,
                    )
                  ),
                ],
              ),
            ),
          );
        }
      ),
      direction: PopoverDirection.top,
      backgroundColor: Theme.of(context).colorScheme.primary,
     );
    },
        
      child: Row(
        children: [
          Icon(
            batterieCapteur == 0
            ? Icons.battery_0_bar
            : batterieCapteur <= 14
            ? Icons.battery_1_bar
            : batterieCapteur <= 28
            ? Icons.battery_2_bar
            : batterieCapteur <= 42
            ? Icons.battery_3_bar
            : batterieCapteur <= 56
            ? Icons.battery_4_bar
            : batterieCapteur <= 70
            ? Icons.battery_5_bar
            : batterieCapteur <= 84
            ? Icons.battery_6_bar
            : Icons.battery_full,
        
            color: batterieCapteur <= 5
            ? Colors.red
            : batterieCapteur <= 20
            ? Colors.orange
            : Colors.green,
            size: 25,
          ),
          Text(
            "$batterieCapteur%",
            style: const TextStyle(
              fontSize: 25,                             
            )
          ),
          Container(
            height: 25,
            alignment: Alignment.topCenter,
            child: const Icon(
              Icons.info_outline,
              size: 15,
            ),
          )
        ]
      ),
    );
  }
}