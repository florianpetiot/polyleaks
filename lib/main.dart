import 'package:flutter/material.dart';
import 'package:polyleaks/pages/page_accueil.dart';
import 'package:polyleaks/pages/page_historique.dart';
import 'package:polyleaks/pages/page_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List ecrans = [
    const PageAccueil(),
    const PageHistorique(),
    const PagePlus(),
  ];

  int indexEcran = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ecrans[indexEcran],
      
      
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'Historique',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Plus',
            )
          ],
      
          currentIndex: indexEcran,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              indexEcran = index;
            });
          },
        )
      ),
    );
  }
}