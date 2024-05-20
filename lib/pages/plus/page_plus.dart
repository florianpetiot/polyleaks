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

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            
            Expanded(
              flex:2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/goutte.png',
                      height: 60,
                    ),
                    const SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 2.5),
                          child: const Text('PolyLeaks', 
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -2.5),
                          child: const Text('version 1.0.0', 
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ),
            
      
      
      
            Expanded(
              flex: 3,
              child: Column(
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
      
                  const SizedBox(height: 20),
      
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
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}