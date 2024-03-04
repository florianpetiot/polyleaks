import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:polyleaks/pages/accueil/page_accueil.dart';
import 'package:polyleaks/pages/historique/page_historique.dart';
import 'package:polyleaks/pages/page_plus.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialiser la base de donnees
  await PolyleaksDatabase.initialize();
  await PolyleaksDatabase().parametresParDefaut();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PolyleaksDatabase()),
          ChangeNotifierProvider(create: (context) => CapteurStateNotifier()),
        ],
        child: const MyApp()
      )
    )
  );
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
        navigatorKey: navigatorKey,
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