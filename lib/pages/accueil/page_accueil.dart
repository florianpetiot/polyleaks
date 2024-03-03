import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/pages/accueil/capteur_slot.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:toastification/toastification.dart';


class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  SMIInput? estTrouve;
  Artboard? riveArtboard;

  @override
  void initState() {
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
            estTrouve = controller.findSMI('etat');
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
      estTrouve!.value = newValue ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final blacklist = context.watch<CapteurStateNotifier>().blacklist;
    final gpsPermission = context.watch<CapteurStateNotifier>().gpsPermission;
    final bluetoothPermission = context.watch<CapteurStateNotifier>().bluetoothPermission;
    final capteurState = context.watch<CapteurStateNotifier>();

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
          
              // Moitié basse de l'écran --------------------------------------------
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: riveArtboard == null
                        ? const Center(child: CircularProgressIndicator())
                        : Rive(artboard: riveArtboard!),
                    ),
          
                    estTrouve == null
                      ? const CircularProgressIndicator()
                      : Switch(
                          value: estTrouve!.value == 1.0 ? true : false, 
                          onChanged: (value) => changerEtat(value),
                        ),
                    
                    (blacklist.isNotEmpty && (capteurState.getSlot(1)["state"] == CapteurSlotState.recherche || capteurState.getSlot(2)["state"] == CapteurSlotState.recherche))
                      ? ElevatedButton(
                          onPressed: () {
                            BluetoothManager().resetBlacklist(context);
                          },
                          child: const Text('Réinitialiser la blacklist'),
                        )
                      : const SizedBox()
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
                  // un container centré avec de l'ombre,
                  // a l'interieur, un texte
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Pour le bon fonctionnement de l\'application, veuillez accorder l\'accès à la localisation et au Bluetooth.',
                            style: TextStyle(
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
                                  title: Text('La demande d\'accès a été refusée.'),
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
                            child: const Text('Autoriser'),
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
}
