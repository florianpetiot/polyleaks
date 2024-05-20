import 'dart:ui';
import 'package:flutter/src/painting/gradient.dart' as grad;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/pages/accueil/capteur_slot.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:toastification/toastification.dart';


class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  SMIInput? etatAnimation;
  Artboard? riveArtboard;

  @override
  void initState() {
    
    // Reset les slot s'ils sont en mode trouve
    for (int slot = 1; slot <= 2; slot++) {
      if (context.read<CapteurStateNotifier>().getSlot(slot)["state"] == CapteurSlotState.trouve) {
        context.read<CapteurStateNotifier>().setSlotState(slot, state: CapteurSlotState.recherche);
      }
    }

    super.initState();

    BluetoothManager().scanForDevices(context);
    rootBundle.load('assets/pipe_animation.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
          if (controller != null) {
            artboard.addController(controller);
            etatAnimation = controller.findSMI('etat');
          }
          setState(() => riveArtboard = artboard);
        }
        catch (e) {
          print(e);
        } 
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    BluetoothManager().stopScan();
  }

  void changerEtat(bool newValue) {
    setState(() {
      etatAnimation!.value = newValue ? 110.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final blacklist = context.watch<CapteurStateNotifier>().blacklist;
    final gpsPermission = context.watch<CapteurStateNotifier>().gpsPermission;
    final bluetoothPermission = context.watch<CapteurStateNotifier>().bluetoothPermission;
    final capteurState = context.watch<CapteurStateNotifier>();
    final db = context.watch<PolyleaksDatabase>();
    db.getParametres();

    var etat1 = context.read<CapteurStateNotifier>().getSlot(1)["state"];
    var etat2 = context.read<CapteurStateNotifier>().getSlot(2)["state"];

    if ((etat1 == CapteurSlotState.recherche || etat1 == CapteurSlotState.trouve) && (etat2 == CapteurSlotState.recherche || etat2 == CapteurSlotState.trouve)) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 0.0;
        });
      }
    }
    else if ((etat1 == CapteurSlotState.recherche || etat1 == CapteurSlotState.trouve) && etat2 == CapteurSlotState.connecte) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 01.0;
        });
      }
    }
    else if ((etat1 == CapteurSlotState.recherche || etat1 == CapteurSlotState.trouve) && etat2 == CapteurSlotState.perdu) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 02.0;
        });
      }
    }
    else if (etat1 == CapteurSlotState.connecte && (etat2 == CapteurSlotState.recherche || etat2 == CapteurSlotState.trouve)) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 10.0;
        });
      }
    }
    else if (etat1 == CapteurSlotState.connecte && etat2 == CapteurSlotState.connecte) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 110.0;
        });
      }
    }
    else if (etat1 == CapteurSlotState.connecte && etat2 == CapteurSlotState.perdu) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 120.0;
        });
      }
    }
    else if (etat1 == CapteurSlotState.perdu && (etat2 == CapteurSlotState.recherche || etat2 == CapteurSlotState.trouve)) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 20.0;
        });
      }
    }
    else if (etat1 == CapteurSlotState.perdu && etat2 == CapteurSlotState.connecte) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 210.0;
        });
      }
    }
    else if (etat1 == CapteurSlotState.perdu && etat2 == CapteurSlotState.perdu) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value = 220.0;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [ Column(
            children: [
              // Moitié haute de l'écran --------------------------------------------
              const Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CapteurSlot(slot: 1,),
                    CapteurSlot(slot: 2,)
                  ],
                )
              ),

              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),

                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            height: 13,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.grey,
                                  width: 1
                                ),
                                )
                              ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          )
                        ),
                        const SizedBox(width: 5),
                        Text(AppLocalizations.of(context)!.accueilComparateur,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            height: 13,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 1
                                ),
                                )
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Expanded(
                    flex: 1,
                    child: SizedBox()
                  ),
                ],
              ),

              // Moitié basse de l'écran --------------------------------------------
              Expanded(
                flex: 3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: riveArtboard == null
                        ? const Center(child: CircularProgressIndicator())
                        : Rive(artboard: riveArtboard!),
                    ),

                    Expanded(
                      flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detectionFuiteTexte(capteurState),
                            
                            (blacklist.isNotEmpty && (capteurState.getSlot(1)["state"] == CapteurSlotState.recherche || capteurState.getSlot(2)["state"] == CapteurSlotState.recherche))
                              ? ElevatedButton(
                                onPressed: () {
                                  BluetoothManager().resetBlacklist(context);
                                },
                                child: Text(AppLocalizations.of(context)!.accueilBlacklistBouton),
                              )
                            : const SizedBox()
                          ],
                        ),

                    )
                   
                  ],
                )
              )
            ],
          ),


          // Autorisation de la localisation ---------------------------------------
          if ((!gpsPermission || !bluetoothPermission) && ![CapteurSlotState.connecte, CapteurSlotState.perdu].contains(capteurState.getSlot(1)["state"]) && ![CapteurSlotState.connecte, CapteurSlotState.perdu].contains(capteurState.getSlot(2)["state"]))
            ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: grad.LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.5),
                        Colors.transparent
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.accueilWarning1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              bool? resultat1 = await BluetoothManager().isLocationActivated(context);
                              bool? resultat2 = await BluetoothManager().isBluetoothActivated(context);
                              if (resultat1 == true && resultat2 == true) {
                                BluetoothManager().scanForDevices(context);
                              }
                              else if (resultat1 == false || resultat2 == false) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.fillColored,
                                  title: Text(AppLocalizations.of(context)!.accueilWarning2),
                                  alignment: Alignment.bottomCenter,
                                  autoCloseDuration: const Duration(seconds: 7),
                                  boxShadow: lowModeShadow,
                                  closeButtonShowType: CloseButtonShowType.none,
                                  closeOnClick: false,
                                  dragToClose: true,
                                  pauseOnHover: false,
                                  showProgressBar: false,
                                );
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.accueilWarningBouton),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ]
        )
      ),
    );
  }


  Widget detectionFuiteTexte(CapteurStateNotifier capteurState) {

    double incoherence = 2*0.03*capteurState.getSlot(1)["valeur"];
    double difference = (capteurState.getSlot(1)["valeur"] - capteurState.getSlot(2)["valeur"]).abs();

    if (!([CapteurSlotState.connecte, CapteurSlotState.perdu].contains(capteurState.getSlot(1)["state"])) || !([CapteurSlotState.connecte, CapteurSlotState.perdu].contains(capteurState.getSlot(2)["state"]))) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 250,
            height: 70,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(144, 202, 249, 0.738),
                  spreadRadius: 2,
                  blurRadius: 50,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          Text(
            AppLocalizations.of(context)!.accueilAnalyse1,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    else if (difference > incoherence) {
      if (etatAnimation != null) {
        setState(() {
          etatAnimation!.value += 1.0;
        });
      }
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 250, 
            height: 70,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(239, 154, 154, 0.803),
                  spreadRadius: 2,
                  blurRadius: 50,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          Text(
            AppLocalizations.of(context)!.accueilAnalyse2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20
            ),
          )
        ],
      );
    }
    else {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 250,
            height: 70,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(165, 214, 167, 1),
                  spreadRadius: 2,
                  blurRadius: 50,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          Text(
            AppLocalizations.of(context)!.accueilAnalyse3,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20
            ),
          ),
        ],
      );
    }
  }
}
