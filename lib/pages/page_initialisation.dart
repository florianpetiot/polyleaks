import 'package:flutter/material.dart';

class PageInitialisationCapteur extends StatefulWidget {
  const PageInitialisationCapteur({super.key});

  @override
  State<PageInitialisationCapteur> createState() => _PageInitialisationCapteurState();
}

class _PageInitialisationCapteurState extends State<PageInitialisationCapteur> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialisation des capteurs'),
      ),
      body: Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
      if (_index < 2) {
        setState(() {
          _index += 1;
        });
      }
    },
      steps: <Step>[
        Step(
          title: const Text('Placement de la bague'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const Text('lorem ipsum'),
        )),
        Step(
          title: const Text('Connexion de la batterie'),
          content: Container(
            alignment: Alignment.centerLeft,
            child : const Text('lorem ipsum'),
        )),
        Step(
          title: const Text('initialisation du capteur'),
          content: Container(
            alignment: Alignment.centerLeft,
            child : const Text('selectionner votre capteur'),
        )),
      ],
    ));
  }
}