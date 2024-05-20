import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/components/bottom_sheet_details.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:polyleaks/pages/historique/tri_popup.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum Tri { numerologique, mesure, batterie, derniereConnexion, dateInitialisation, distance }

class VueListe extends StatefulWidget {
  const VueListe({super.key});

  @override
  State<VueListe> createState() => _VueListeState();
}

class _VueListeState extends State<VueListe> {
  final GlobalKey _clipRRectKey = GlobalKey();
  List<Map<String, dynamic>>? capteurs;
  final ScrollController _scrollController = ScrollController();
  final List<PageController> _pageControllers = [];
  bool decroissant = false;
  var tri = Tri.numerologique;
  late Position positionGps;

  @override
  void initState() {
    super.initState();
    loadCapteurs();
  }

  void loadCapteurs() {
    Future.microtask(() async {
      capteurs = await PolyleaksDatabase().getDetailsCapteurs();
      _pageControllers.addAll(List.generate(capteurs!.length, (index) => PageController()));
      nouveauTri(Tri.numerologique);
      setState(() {});
    });
  }

  void nouveauTri(newTri, {Position? positionGps}){
    int pageIndex;

    setState(() {

      tri = newTri;
      if (positionGps != null) {
        this.positionGps = positionGps;
      }

      switch (tri) {
        case Tri.numerologique:
          capteurs!.sort((a, b) {
            var aNum = int.parse(a['nom'].split('-').last);
            var bNum = int.parse(b['nom'].split('-').last);
            return aNum.compareTo(bNum);
          });
          pageIndex = 0;
          break;
        case Tri.mesure:
          capteurs!.sort((a, b) => a['valeur'].compareTo(b['valeur']));
          pageIndex = 0;
          break;
        case Tri.batterie:
          capteurs!.sort((a, b) => a['batterie'].compareTo(b['batterie']));
          pageIndex = 1;
          break;
        case Tri.derniereConnexion:
          capteurs!.sort((a, b) => a['dateDerniereConnexion'].compareTo(b['dateDerniereConnexion']));
          pageIndex = 2;
          break;
        case Tri.dateInitialisation:
          capteurs!.sort((a, b) => a['dateInitialisation'].compareTo(b['dateInitialisation']));
          pageIndex = 3;
          break;
        case Tri.distance:
          capteurs!.sort((a, b) {
            var aDistance = Geolocator.distanceBetween(a['localisation'][0], a['localisation'][1], positionGps!.latitude, positionGps.longitude);
            var bDistance = Geolocator.distanceBetween(b['localisation'][0], b['localisation'][1], positionGps.latitude, positionGps.longitude);
            return aDistance.compareTo(bDistance);
          });
          pageIndex = 4;
          break;
      }
    
      rollcontrollers(pageIndex);

      if (decroissant) {
        capteurs  = capteurs!.reversed.toList();
      }

    });
  }

  void rollcontrollers(pageIndex) async {
    for (var i = 0; i < capteurs!.length; i++) {
      if(_pageControllers[i].hasClients && _pageControllers[i].page != pageIndex.toDouble()) {
        _pageControllers[i].animateToPage(pageIndex, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }
  }
    


  @override
  void dispose() {
    _scrollController.dispose();
    for (var pageController in _pageControllers) {
      pageController.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          if (capteurs == null)
            const Center(
              child: CircularProgressIndicator(),
            )

          else if (capteurs!.isEmpty)
            const Center(
              child: Text('Aucun capteur dans la base de données'),
            )

          else
            ListView.builder(
              itemCount: capteurs!.length + 1,
              itemBuilder: (context, index) {

                // si on a atteint la fin de la liste, on retourne un espace vide
                // pour ne pas se supperposer avec le menu
                if (index == capteurs!.length) {
                  return const SizedBox(height: 80);
                }

                final capteur = capteurs![index];

                return GestureDetector(
                  onTap: () => showBottomSheetDetails(context, vueMaps: true, vueSlot: true, nom: capteur['nom']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [

                            // titre
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                capteur['nom'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // sous-titre
                            SizedBox(
                              width: 300,
                              height: 75,
                              child: Scrollbar(
                                thumbVisibility: true,
                                thickness: 2,
                                controller: _scrollController,  
                                child: PageView(
                                  controller: _pageControllers[index],
                                  children : buildCapteurDetails(capteur).map((widget){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: widget
                                    );
                                  }).toList()
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                      ]
                    ),
                  ),
                );
              }),


          // navigation tools
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 54,
                width: 245,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // croissant / decroissant
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          decroissant = !decroissant;
                          // print(decroissant);
                        });
                        nouveauTri(tri);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(decroissant ? 3.145926 : 0),
                              child: Icon(
                                Icons.north,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ClipRRect(
                    key: _clipRRectKey,
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child:GestureDetector(
                        onTap: () { showPopover(context: _clipRRectKey.currentContext!, 
                          bodyBuilder: (context) {
                            return SizedBox(
                              height: 336,
                              width: 245,
                              child: TriPopup(
                                triActuel: tri,
                                onTriSelected: (newTri, {Position? position}) {
                                  nouveauTri(newTri, positionGps: position);
                                },
                              ),
                            );
                          },
                          direction: PopoverDirection.top,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        );},
                        child: Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.filter_alt_rounded,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      )
                      ),  
                    ),        
                  ],
                ),
              )
            )
          )
        ]
      ),
    );
  }

  List<Widget> buildCapteurDetails(Map<String, dynamic> capteur) {
    final List<Widget> details = [];
    var valeur = capteur['valeur'];
    int batterie = capteur['batterie'];
    DateTime dateDerniereConnexion = capteur['dateDerniereConnexion'];
    double? distance;
    String? distanceString;

    if (capteur['nom'] == context.read<CapteurStateNotifier>().getSlot(1)["nom"] && context.read<CapteurStateNotifier>().getSlot(1)["state"] == CapteurSlotState.connecte) {
      valeur = context.watch<CapteurStateNotifier>().getSlot(1)["valeur"];
      dateDerniereConnexion = context.watch<CapteurStateNotifier>().getSlot(1)["derniereConnexion"];
    }

    else if (capteur['nom'] == context.read<CapteurStateNotifier>().getSlot(2)["nom"] && context.read<CapteurStateNotifier>().getSlot(2)["state"] == CapteurSlotState.connecte) {
      valeur = context.watch<CapteurStateNotifier>().getSlot(2)["valeur"];
      dateDerniereConnexion = context.watch<CapteurStateNotifier>().getSlot(2)["derniereConnexion"];
    }


    details.add(
      Text(
        '${AppLocalizations.of(context)!.bs1} : $valeur L/h',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );

    details.add(
      Text(
        '${AppLocalizations.of(context)!.liste1} : $batterie%',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      )
    );

    details.add(
      Text(
        '${AppLocalizations.of(context)!.bs2} : ${DateFormat('dd/MM/yy HH:mm:ss').format(dateDerniereConnexion)}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
    

    details.add(
      Text(
        '${AppLocalizations.of(context)!.bs3} : ${DateFormat('dd/MM/yy HH:mm:ss').format(capteur['dateInitialisation'])}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );

    // texte "ouvrir dans google maps"

    if (tri == Tri.distance) {
      distance = Geolocator.distanceBetween(capteur['localisation'][0], capteur['localisation'][1], positionGps.latitude, positionGps.longitude);
      distanceString = distance > 1000 ? "à ${(distance / 1000).toStringAsFixed(2)} kilomètres" : "à ${distance.toStringAsFixed(2)} mètres";
    }

    details.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [   
          Text("${AppLocalizations.of(context)!.liste2} : ",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            )
          ),

          if (tri == Tri.distance) 
          Text(
            distanceString!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          )
          

          else
          GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=${capteur['localisation'][0]},${capteur['localisation'][1]}"));
            },
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.bs4,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    )),
                  const SizedBox(width: 5),
                  const Icon(Icons.open_in_new, color: Colors.blue, size: 14),
                ]
              ),
            ),
          ),
        ],
      ),
    ); 

    return details;
  }
}