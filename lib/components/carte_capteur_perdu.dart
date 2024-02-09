import 'package:flutter/material.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class CarteCapteurPerdu extends StatefulWidget {
  final int slot;

  const CarteCapteurPerdu(
      {super.key,
      required this.slot});

  @override
  State<CarteCapteurPerdu> createState() => _CarteCapteurPerduState();
}

class _CarteCapteurPerduState extends State<CarteCapteurPerdu> {


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {});
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    deductionTempsLive(capteurState.getSlot(widget.slot)["derniereConnexion"]);
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  void setCapteurState(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    capteurState.setSlotState(widget.slot, state: CapteurSlotState.recherche);
  }


  late String tempsDeduit;
  late Timer _timer;

  void deductionTempsLive(derniereConnexion) {
    String temps;

    final difference = DateTime.now().difference(derniereConnexion);
    Duration interval;

    if (difference.inDays > 0) {
      // afficher la date et sortir de la fonction
      temps = 'Vu le ${derniereConnexion.day}/${derniereConnexion.month}/${derniereConnexion.year}';
      setState(() {
        tempsDeduit = temps;
      });
      return;
    } else if (difference.inHours > 0) {
      temps = 'Vu il y a ${difference.inHours}h';
      interval = const Duration(hours: 1);
    } else if (difference.inMinutes > 0) {
      temps = 'Vu il y a ${difference.inMinutes}m';
      interval = const Duration(minutes: 1);
    } else {
      temps = 'Vu il y a ${difference.inSeconds}s';
      interval = const Duration(seconds: 1);
    }

    setState(() {
      tempsDeduit = temps;
    });

    // Cancel the previous timer if it exists
    if(_timer.isActive) {
      _timer.cancel();
    }

    // Start a new timer
    _timer = Timer.periodic(interval, (Timer t) => deductionTempsLive(derniereConnexion));
  }


  String getNomCapteur(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
    return capteurState.getSlot(widget.slot)["nom"];
  }

  double getValeurCapteur(context) {
    final capteurState = Provider.of<CapteurStateNotifier>(context);
    return capteurState.getSlot(widget.slot)["valeur"];
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 185,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFB7B7B7),
            width: 1,
          ),
        ),

        // Contenu de la carte ---------------------------------------------------
        // un point bleu aligné avec un texte au centre vertical de la carte
        // la hauteur de la carte prend toute la hauteur disponible
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              Text(
                // recuperer le nom depuis le provider
                getNomCapteur(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Text(
                    tempsDeduit,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ]),

            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getValeurCapteur(context).toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'm/s',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // bouton se connecter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Détails',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),

                  ElevatedButton(
                      onPressed: () => setCapteurState(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.cancel, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
