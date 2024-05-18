import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopupErreur extends StatelessWidget {
  final int idErreur;

  const PopupErreur({Key? key, required this.idErreur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color? iconColor;
    String title;
    String content;
    List<Widget> actions = [
       TextButton(
        child: const Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ];


    switch (idErreur) {

      case 0:
      // erreur inconnue
        iconData = Icons.error;
        iconColor = Colors.red;
        title = AppLocalizations.of(context)!.erreur0Titre;
        content = AppLocalizations.of(context)!.erreur0Description;
        break;

      case 1:
      // capteur introuvable
        iconData = Icons.warning;
        iconColor = Colors.orange;
        title = AppLocalizations.of(context)!.erreur1Titre;
        content = AppLocalizations.of(context)!.erreur1Description;
        break;

      case 2:
      // capteur non initialisé
        iconData = Icons.warning;
        iconColor = Colors.orange;
        title = AppLocalizations.of(context)!.erreur2Titre;
        content = AppLocalizations.of(context)!.erreur2Description;
        break;

      case 3:
      // permission non accepetée
        iconData = Icons.settings;
        title = AppLocalizations.of(context)!.erreur3Titre;
        content = AppLocalizations.of(context)!.erreur3Description;
        break;

      case 4:
      // permission refusée définitivement
        iconData = Icons.settings;
        title =  AppLocalizations.of(context)!.erreur4Titre;
        content = AppLocalizations.of(context)!.erreur4Description;
        actions = [
          TextButton(
            child: Text(AppLocalizations.of(context)!.erreur4Bouton1),
            onPressed: () async {
              await Geolocator.openAppSettings();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.erreur4Bouton2),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ];
        break;
      
      case 5:
        // activation manuelle du bluetooth
        iconData = Icons.bluetooth_rounded;
        title = AppLocalizations.of(context)!.erreur5Titre;
        content = AppLocalizations.of(context)!.erreur5Description;
        break;

      default:
      // erreur inconnue
        iconData = Icons.error;
        iconColor = Colors.red;
        title = AppLocalizations.of(context)!.erreur0Titre;
        content = AppLocalizations.of(context)!.erreur0Description;
    }

    return AlertDialog(
      icon: Icon(iconData, color: iconColor),
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
}