import 'package:flutter/material.dart';

class PopupErreur extends StatelessWidget {
  final int idErreur;

  const PopupErreur({Key? key, required this.idErreur}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      icon: idErreur == 1 ? const Icon(Icons.warning) : const Icon(Icons.info),
      iconColor: idErreur == 1 ? Colors.orange : Colors.blue,
      title:
          idErreur == 1 ? const Text('Capteur introuvable') : const Text('Capteur non initialisé'),
      content: idErreur == 1
          ? const Text('Le capteur que vous essayez de joindre n\'est plus à proximité.\nVeuillez vous en raprocher puis réessayer.')
          : const Text('Le capteur que vous essayez de joindre n\'a pas été initialisé.\nVeuillez vous rendre dans la partie "Plus" pour l\'initialiser puis réessayer.'),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

  }
}