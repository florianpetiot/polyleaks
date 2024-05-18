import 'package:flutter/material.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/pages/plus/page_a_propos.dart';
import 'package:polyleaks/pages/plus/page_initialisation.dart';
import 'package:provider/provider.dart';

class PagePlus extends StatefulWidget {
  const PagePlus({Key? key}) : super(key: key);

  @override
  _PagePlusState createState() => _PagePlusState();
}

class _PagePlusState extends State<PagePlus> {
  String dropdownValue = 'Francais';
  bool isDarkModeEnabled = false;

  void _changeLanguage(String language) {
    PolyleaksDatabase().setParametre('langue', language == 'Francais' ? 0 : 1);
    setState(() {
      dropdownValue = language;
    });
    print(language);
  }

  @override
  Widget build(BuildContext context) {

    final db = context.watch<PolyleaksDatabase>();
    db.getParametres();

    return Scaffold(
      body: ListView(
        children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.plus1),
          trailing: DropdownButton<String>(
            value: context.watch<PolyleaksDatabase>().langue == const Locale('fr') ? 'Francais' : 'English',
            onChanged: (String? newValue) {
              _changeLanguage(newValue!);
            },
            items: <String>['Francais', 'English']
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
          title: Text(AppLocalizations.of(context)!.plus2),
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
          title: Text(AppLocalizations.of(context)!.aPropos0),
          leading: const Icon(Icons.info),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PageAPropos(),
              ),
            );
          },
        ),

        // initialisation d'un capteur
        ListTile(
          title: Text(AppLocalizations.of(context)!.plus4),
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