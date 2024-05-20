import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:polyleaks/pages/historique/vue_liste.dart';
import 'package:toastification/toastification.dart';


class TriPopup extends StatefulWidget {
  final Tri triActuel;
  final Function(Tri newTri, {Position? position}) onTriSelected;
  const TriPopup({super.key, required this.triActuel, required this.onTriSelected});

  @override
  State<TriPopup> createState() => _TriPopupState();
}

class _TriPopupState extends State<TriPopup> {

  bool enCours = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          // numérologique
          InkWell(
            onTap: () {
              widget.onTriSelected(Tri.numerologique);
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.liste3),
              leading: const Icon(Icons.numbers),
              iconColor: widget.triActuel == Tri.numerologique ? Colors.blue : Colors.grey,
            ),
          ),
          
          // mesure
          InkWell(
            onTap: () {
              widget.onTriSelected(Tri.mesure);
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.bs1),
              leading: const Icon(Icons.speed),
              iconColor: widget.triActuel == Tri.mesure ? Colors.blue : Colors.grey,
            ),
          ),

          // batterie
          InkWell(
            onTap: () {
              widget.onTriSelected(Tri.batterie);
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.liste1),
              leading: const Icon(Icons.battery_full),
              iconColor: widget.triActuel == Tri.batterie ? Colors.blue : Colors.grey,
            ),
          ),

          // dernière connexion
          InkWell(
            onTap: () {
              widget.onTriSelected(Tri.derniereConnexion);
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.bs2),
              leading: const Icon(Icons.access_time),
              iconColor: widget.triActuel == Tri.derniereConnexion ? Colors.blue : Colors.grey,
            ),
          ),

          // date d'initialisation
          InkWell(
            onTap: () {
              widget.onTriSelected(Tri.dateInitialisation);
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.bs3),
              leading: const Icon(Icons.calendar_today),
              iconColor: widget.triActuel == Tri.dateInitialisation ? Colors.blue : Colors.grey,
            ),
          ),

          // distance
          InkWell(
            onTap: () async {
              try {
                setState(() {
                  enCours = true;
                });
                var newPosition = await Geolocator.getCurrentPosition();
                widget.onTriSelected(Tri.distance, position: newPosition);
              }
              catch (e) {
                toastification.show(
                  context: context,
                  type: ToastificationType.error,
                  style: ToastificationStyle.fillColored,
                  title: Text(AppLocalizations.of(context)!.accueilWarning2),
                  alignment: Alignment.bottomCenter,
                  autoCloseDuration: const Duration(seconds: 5),
                  boxShadow: lowModeShadow,
                  closeButtonShowType: CloseButtonShowType.none,
                  closeOnClick: false,
                  dragToClose: true,
                  pauseOnHover: false,
                  showProgressBar: false,
                );
              }
              Navigator.pop(context);
            },
            child: ListTile(
              title: const Text('Distance'),
              leading: const Icon(Icons.place),
              trailing: !enCours 
                ? null
                : const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 2.5,
                  ) 
                ),
              iconColor: widget.triActuel == Tri.distance ? Colors.blue : Colors.grey,
            ),
          ),
        ]
      ),
    );
  }
}