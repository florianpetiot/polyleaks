import 'package:flutter/material.dart';
import 'package:polyleaks/pages/plus/page_initialisation.dart';

class PagePlus extends StatefulWidget {
  const PagePlus({Key? key}) : super(key: key);

  @override
  _PagePlusState createState() => _PagePlusState();
}

class _PagePlusState extends State<PagePlus> {
  String dropdownValue = 'Francais';
  bool isDarkModeEnabled = false;

  void _changeLanguage(String language) {
    setState(() {
      dropdownValue = language;
    });
    print(language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
        ListTile(
          title: Text('Langue'),
          trailing: DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              _changeLanguage(newValue!);
            },
            items: <String>['Francais', 'Anglais', 'Espagnol']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          leading: const Icon(Icons.language),
        ),

        // switch mode sombre / clair
        ListTile(
          title: const Text('Mode sombre'),
          trailing: Switch(
            value: isDarkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                isDarkModeEnabled = value;
              });
              print(value);
            },
          ),
          leading: const Icon(Icons.nightlight_round),
        ),

        // A propos
        ListTile(
          title: const Text('A propos'),
          leading: const Icon(Icons.info),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'PolyLeaks',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.info),
              children: const [
                Text('Application de gestion de capteurs'),
              ],
            );
          },
        ),

        // initialisation d'un capteur
        ListTile(
          title: const Text('Initialiser un capteur'),
          leading: const Icon(Icons.add),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PageInitialisationCapteur(),
              ),
            );
          },
        ),
      ]),
    );
  }
}