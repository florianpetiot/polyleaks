import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/pages/accueil/capteur_slot.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';


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
    final capteurState = context.watch<CapteurStateNotifier>();

    return SafeArea(
      child: Scaffold(
        body: Column(
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
          )),
      
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
      )),
    );
  }
}
