import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:polyleaks/pages/accueil/page_accueil.dart';
import 'package:polyleaks/pages/historique/page_historique.dart';
import 'package:polyleaks/pages/plus/page_plus.dart';
import 'package:polyleaks/theme/dark_theme.dart';
import 'package:polyleaks/theme/light_theme.dart';
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white.withOpacity(0.002),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));


    return ChangeNotifierProvider(
      create: (context) => PolyleaksDatabase(),
      builder: (context, child) {
        final provider = Provider.of<PolyleaksDatabase>(context);

      return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,

          theme: lightTheme,
          darkTheme: darkTheme,

          locale: provider.langue,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],

          home: Scaffold(
            body: ecrans[indexEcran],
          
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: provider.langue == const Locale('fr') ? 'Accueil' : 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history_rounded),
                  label: provider.langue == const Locale('fr') ? 'Historique' : 'History',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.more_horiz),
                  label: provider.langue == const Locale('fr') ? 'Plus' : 'More',
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
    );
  }
}