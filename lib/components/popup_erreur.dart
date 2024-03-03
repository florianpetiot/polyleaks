import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
        title = 'Erreur inconnue';
        content = 'Une erreur inconnue s\'est produite.';
        break;

      case 1:
      // capteur introuvable
        iconData = Icons.warning;
        iconColor = Colors.orange;
        title = 'Capteur introuvable';
        content = 'Le capteur que vous essayez de joindre n\'est plus à proximité.\nVeuillez vous en raprocher puis réessayer.';
        break;

      case 2:
      // capteur non initialisé
        iconData = Icons.info;
        iconColor = Colors.blue;
        title = 'Capteur non initialisé';
        content = 'Le capteur que vous essayez de joindre n\'a pas été initialisé.\nVeuillez vous rendre dans la partie "Plus" pour l\'initialiser puis réessayer.';
        break;

      case 3:
      // permission non accepetée
        iconData = Icons.settings;
        title = 'Permission requise';
        content = 'Pour le bon fonctionnement de cette application, veuiller accorder la permission d\'accès à la localisation GPS.';
        break;

      case 4:
      // permission refusée définitivement
        iconData = Icons.settings;
        title = 'Permission requise';
        content = 'Vous avez refusé la permission d\'accès à la localisation GPS de manière définitive.\nPour le bon fonctionnement de cette application, veuiller accorder la permission d\'accès à la localisation GPS dans les paramètres de votre appareil.';
        actions = [
          TextButton(
            child: const Text('Aller aux paramètres'),
            onPressed: () async {
              await Geolocator.openAppSettings();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Abandonner'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ];
        break;
      
      case 5:
        // activation manuelle du bluetooth
        iconData = Icons.bluetooth_rounded;
        title = 'Bluetooth désactivé';
        content = 'Pour le bon fonctionnement de cette application, veuiller activer le Bluetooth de votre appareil.';
        break;

      default:
      // erreur inconnue
        iconData = Icons.error;
        iconColor = Colors.red;
        title = 'Erreur inconnue';
        content = 'Une erreur inconnue s\'est produite.';
    }

    return AlertDialog(
      icon: Icon(iconData, color: iconColor),
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
}