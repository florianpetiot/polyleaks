import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/historique/vue_liste.dart';
import 'package:polyleaks/pages/historique/vue_maps.dart';
import 'package:provider/provider.dart';

class PageHistorique extends StatefulWidget {
  const PageHistorique({super.key});

  @override
  State<PageHistorique> createState() => _PageHistoriqueState();
}

class _PageHistoriqueState extends State<PageHistorique> {

  int _selectedIndex = 0;

  List ecran = [
    const VueMaps(),
    const VueListe(),
  ];
 

  @override
  Widget build(BuildContext context) {
    final db = context.read<PolyleaksDatabase>();
    _selectedIndex = db.historiqueIndexPage;

    return Scaffold(
      body: Stack(
        children: [

          // ecran
          ecran[_selectedIndex],
          


          // navigation bar perso
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Wrap(
                      children: <Widget>[

                        GestureDetector(
                          onTap: () {
                            db.historiqueIndexPage = 0;
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            child: Icon(
                              Icons.map,
                              color: _selectedIndex == 0 ? Colors.blue : Theme.of(context).colorScheme.tertiary,
                              size: 30,
                              ),
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 30,
                          // add padding
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          color: Colors.grey.withOpacity(0.5),
                        ),

                        GestureDetector(
                          onTap: () {
                            db.historiqueIndexPage = 1;
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            child: Icon(
                              Icons.list, 
                              color: _selectedIndex == 1 ? Colors.blue : Theme.of(context).colorScheme.tertiary,
                              size: 30,
                              ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
