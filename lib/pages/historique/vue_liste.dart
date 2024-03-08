import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polyleaks/components/bottom_sheet_details.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:popover/popover.dart';

enum Tri { numerologique, mesure, derniereConnexion, dateInitialisation, distance }

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

  @override
  void initState() {
    super.initState();
    loadCapteurs();
  }

  void loadCapteurs() {
    Future.microtask(() async {
      capteurs = await PolyleaksDatabase().getDetailsCapteurs();
      _pageControllers.addAll(List.generate(capteurs!.length, (index) => PageController()));
      nouveauTri();
      setState(() {});
    });
  }

  void nouveauTri() {
    int pageIndex;

    setState(() {
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
      case Tri.derniereConnexion:
        capteurs!.sort((a, b) => a['dateDerniereConnexion'].compareTo(b['dateDerniereConnexion']));
        pageIndex = 1;
        break;
      case Tri.dateInitialisation:
        capteurs!.sort((a, b) => a['dateInitialisation'].compareTo(b['dateInitialisation']));
        pageIndex = 2;
        break;
      case Tri.distance:
        capteurs!.sort((a, b) => a['localisation'][0].compareTo(b['localisation'][0]));
        pageIndex = 3;
        break;
    }
    
    for (var i = 0; i < capteurs!.length; i++) {
      if(_pageControllers[i].hasClients) {
        _pageControllers[i].animateToPage(pageIndex, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    }

    if (decroissant) {
      capteurs  = capteurs!.reversed.toList();
    }

    });
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
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
                                thickness: 1,
                                controller: _scrollController,  
                                child: PageView(
                                  controller: _pageControllers[index],
                                  children : buildCapteurDetails(capteur).map((text){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Text(
                                        text,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
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
                        nouveauTri();
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
                                color: Colors.grey[600],
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
                              height: 280,
                              width: 245,
                              child: listeTri(),
                            );
                          },
                          direction: PopoverDirection.top,
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
                            color: Colors.grey[600],
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

  Widget listeTri() {
    return Material(
      child: Column(
        children: [
          // numérologique
          InkWell(
            onTap: () {
              setState(() {
                tri = Tri.numerologique;
              });
              nouveauTri();
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Numérologique'),
              leading: Icon(Icons.numbers),
              iconColor: tri == Tri.numerologique ? Colors.blue : Colors.grey,
            ),
          ),
          
          // mesure
          InkWell(
            onTap: () {
              setState(() {
                tri = Tri.mesure;
              });
              nouveauTri();
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Mesure'),
              leading: Icon(Icons.speed),
              iconColor: tri == Tri.mesure ? Colors.blue : Colors.grey,
            ),
          ),

          // dernière connexion
          InkWell(
            onTap: () {
              setState(() {
                tri = Tri.derniereConnexion;
              });
              nouveauTri();
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Dernière connexion'),
              leading: Icon(Icons.access_time),
              iconColor: tri == Tri.derniereConnexion ? Colors.blue : Colors.grey,
            ),
          ),

          // date d'initialisation
          InkWell(
            onTap: () {
              setState(() {
                tri = Tri.dateInitialisation;
              });
              nouveauTri();
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Date d\'initialisation'),
              leading: Icon(Icons.calendar_today),
              iconColor: tri == Tri.dateInitialisation ? Colors.blue : Colors.grey,
            ),
          ),

          // distance
          InkWell(
            onTap: () {
              setState(() {
                tri = Tri.distance;
              });
              nouveauTri();
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Distance'),
              leading: Icon(Icons.place),
              iconColor: tri == Tri.distance ? Colors.blue : Colors.grey,
            ),
          ),
        ]
      ),
    );
  }



  List<String> buildCapteurDetails(Map<String, dynamic> capteur) {
    final List<String> details = [];
    details.add('Mesure : ${capteur['valeur']}');
    details.add('Derniere connexion : ${DateFormat('dd/MM/yy HH:mm:ss').format(capteur['dateDerniereConnexion'])}');
    details.add('Date d\'initialisation : ${DateFormat('dd/MM/yy HH:mm:ss').format(capteur['dateInitialisation'])}');
    details.add('Localisation : ${capteur['localisation'][0]}, ${capteur['localisation'][1]}');
    return details;
  }
}