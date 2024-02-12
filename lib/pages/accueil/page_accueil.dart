import 'package:flutter/material.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/pages/accueil/capteur_slot.dart';


class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {

  @override
  void initState() {
    super.initState();
    BluetoothManager().scanForDevices(context);
  }

  @override
  void dispose() {
    super.dispose();
    BluetoothManager().stopScan();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Container(
            
          ))
        ],
      )),
    );
  }
}
