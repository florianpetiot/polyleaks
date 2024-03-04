import 'dart:ui';

import 'package:flutter/material.dart';

class VueListe extends StatefulWidget {
  const VueListe({super.key});

  @override
  State<VueListe> createState() => _VueListeState();
}

class _VueListeState extends State<VueListe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          const Center(
            child: Text(
              'Liste des capteurs',
              style: TextStyle(
                fontSize: 18
              ),
            ),
          ),


          // navigation tools
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 54,
                width: 245,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
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
                          child: const Icon(
                            Icons.filter_alt,
                            color: Colors.blue,
                          ),
                        ),
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
}
