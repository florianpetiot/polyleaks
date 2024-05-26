import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



  /// EtatEtape est une enumeration qui permet de definir l'etat d'une etape du processus d'initialisation
  /// - **attente** : l'etape est en attente
  /// - **enCours** : l'etape est en cours
  /// - **reussie** : l'etape a reussie
  /// - **echec** :
  /// 
  ///   - pour l'etape de la localisation : la localisation n'a pas pu etre obtenue
  /// 
  ///   - pour l'etape de la transmission : la connexion avec le capteur a echoue
  /// 
  /// - **echec2** :
  /// 
  ///   - pour l'etape de la transmission : le capteur a deja ete initialise
enum EtatEtape {attente, enCours, reussie, echec, echec2}
 
class PageInitialisationCapteur extends StatefulWidget {
  const PageInitialisationCapteur({super.key});

  @override
  State<PageInitialisationCapteur> createState() => _PageInitialisationCapteurState();
}

class _PageInitialisationCapteurState extends State<PageInitialisationCapteur> { 
  int _index = 0;
  final PageController _pageController = PageController();
  ValueNotifier<dynamic> selectedDevice = ValueNotifier<dynamic>(null);

  ValueNotifier<EtatEtape> etapeLocalisation = ValueNotifier<EtatEtape>(EtatEtape.attente);
  ValueNotifier<EtatEtape> etapeTransmission = ValueNotifier<EtatEtape>(EtatEtape.attente);
  EtatEtape processus = EtatEtape.attente;
  

  @override
  void dispose() {
    selectedDevice.dispose();
    etapeLocalisation.dispose();
    etapeTransmission.dispose();
    BluetoothManager().stopScan();
    super.dispose();
  }

  void _showDescriptionPage(ScanResult device) {
    
    // reinitialiser la page
    selectedDevice.value = device;
    etapeLocalisation.value = EtatEtape.attente;
    etapeTransmission.value = EtatEtape.attente;
    processus = EtatEtape.attente;

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }


  void initialisationCapteur(BluetoothDevice device) async {
    processus = EtatEtape.enCours;
    Position position;

    // recuperation de la localisation
    try {
      etapeLocalisation.value = EtatEtape.enCours;
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      etapeLocalisation.value = EtatEtape.reussie;
    } catch (e) {
      etapeLocalisation.value = EtatEtape.echec;
      processus = EtatEtape.echec;
      return;
    }

    // transmission des données
    etapeTransmission.value = EtatEtape.enCours;
    List<bool> resultat = await BluetoothManager().transmissionPosition(device, position);

    if (!resultat[0]) {
      etapeTransmission.value = EtatEtape.echec;
      processus = EtatEtape.echec;
      return;
    }
    else if (!resultat[1]) {
      etapeTransmission.value = EtatEtape.echec2;
      processus = EtatEtape.echec;
      return;
    }
    else {
      etapeTransmission.value = EtatEtape.reussie;
      processus = EtatEtape.reussie;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.initCapteursTitre),
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

      controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
        return Row(
          children: <Widget>[
            if (_index != 2)
            ElevatedButton(
              onPressed: controlsDetails.onStepContinue,
              child: Text(AppLocalizations.of(context)!.initCapteursStep1),
            ),
            if (_index != 0)
            TextButton(
              onPressed: controlsDetails.onStepCancel,
              child: Text(AppLocalizations.of(context)!.initCapteursStep2),
            ),
          ]
        );
      },

      steps: <Step>[
        Step(
          title: Text(AppLocalizations.of(context)!.initCapteurs1),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.initCapteurs1Consigne),
              const Image(image: AssetImage('assets/init1.png')),
            ],
        )),

        Step(
          title: Text(AppLocalizations.of(context)!.initCapteurs2),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              Text(AppLocalizations.of(context)!.initCapteurs2Consigne),
              const Image(image: AssetImage('assets/init2.png')),
            ],
        )),

        Step(
          title: Text(AppLocalizations.of(context)!.initCapteurs3),
          content: SizedBox(
            height: 260,
            width: 300,
            child : FutureBuilder<Stream<List<ScanResult>>>(
              future: BluetoothManager().getScanList(context, _index),
              builder: (BuildContext context, AsyncSnapshot<Stream<List<ScanResult>>> snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.initCapteursSetUp),
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                    ],
                  );
                }
                else if (snapshot.hasError) {
                  return Text('Error : ${snapshot.error}');
                }

                else {

                  // afficher la liste du scan
                  return StreamBuilder<List<ScanResult>>(
                    stream: snapshot.data,
                    builder: (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else if (snapshot.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Pour pouvoir démarer un scan,\nveuillez accorder l\'accès à la localisation et au bluetooth.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  
                                });
                              },
                              child: const Text('Autoriser'),
                            ),
                          ], 
                        );
                      }
                      else if (!snapshot.hasData) {
                        return Text(AppLocalizations.of(context)!.initCapteurs3Titre);
                      }

                      else {
                        return PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Text(AppLocalizations.of(context)!.initCapteurs3Titre, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    LinearProgressIndicator(
                                      backgroundColor: Colors.transparent,
                                      color: Colors.blue[200],
                                      minHeight: 2,
                                    ),  
                                  ],
                                ),

                                Expanded(
                                  child: ListView.builder(
                                    itemCount:  snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var advName = snapshot.data![index].advertisementData.advName;                      
                                  
                                      if (!advName.startsWith("Polyleaks-")) {
                                        return const SizedBox.shrink();
                                      }
                                  
                                      return ListTile(
                                        title: Text(advName),
                                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                        onTap: () {
                                          _showDescriptionPage(snapshot.data![index]);
                                        }
                                      );
                                  }),
                                ),
                              ],
                            ),

                            ValueListenableBuilder(
                              valueListenable: selectedDevice,
                              builder: (BuildContext context, dynamic result, Widget? child) {
                                
                                String nomCapteur = result == null ? '' : result.advertisementData.advName;

                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text(nomCapteur),
                                    centerTitle: true,
                                    leading: IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        _pageController.previousPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ),
                                  body: Padding(
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 45),
                                          child: Text(
                                            AppLocalizations.of(context)!.initCapteurs4,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        
                                        ElevatedButton(
                                          onPressed: () {
                                            initialisationCapteur(result.device);
                                          },
                                          child: Text(AppLocalizations.of(context)!.initCapteurs4Bouton),
                                        ),

                                        Column(
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: etapeLocalisation,
                                              builder: (BuildContext context, EtatEtape etapeLoc, Widget? child) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 17,
                                                      width: 17,
                                                      child: etapeLoc == EtatEtape.attente 
                                                            ? const SizedBox.shrink()
                                                            : etapeLoc == EtatEtape.enCours 
                                                              ? const CircularProgressIndicator(strokeWidth: 2,)
                                                              : etapeLoc == EtatEtape.reussie 
                                                                ? const Icon(Icons.check_circle, color: Colors.green, size: 17,)
                                                                : const Icon(Icons.cancel, color: Colors.red, size: 17,)
                                                    ),
                                                    const SizedBox(width: 10),
                                                
                                                    etapeLoc == EtatEtape.attente
                                                      ? const SizedBox.shrink()
                                                      : etapeLoc == EtatEtape.enCours
                                                        ? Text(AppLocalizations.of(context)!.initCapteurs4GPS1)
                                                        : etapeLoc == EtatEtape.reussie
                                                          ? Text(AppLocalizations.of(context)!.initCapteurs4GPS2)
                                                          : Text(AppLocalizations.of(context)!.initCapteurs4GPS3)
                                                  ],
                                                );
                                              }
                                            ),

                                            const SizedBox(height: 10),
                                            
                                            ValueListenableBuilder(
                                              valueListenable: etapeTransmission,
                                              builder: (BuildContext context, EtatEtape etapeTransmi, Widget? child) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 17,
                                                      width: 17,
                                                      child: etapeTransmi == EtatEtape.attente 
                                                            ? const SizedBox.shrink()
                                                            : etapeTransmi == EtatEtape.enCours 
                                                              ? const CircularProgressIndicator(strokeWidth: 2,)
                                                              : etapeTransmi == EtatEtape.reussie 
                                                                ? const Icon(Icons.check_circle, color: Colors.green, size: 17,)
                                                                : const Icon(Icons.cancel, color: Colors.red, size: 17,)
                                                    ),
                                                    const SizedBox(width: 10),
                                                
                                                    etapeTransmi == EtatEtape.attente
                                                      ? const SizedBox.shrink()
                                                      : etapeTransmi == EtatEtape.enCours
                                                        ? Text(AppLocalizations.of(context)!.initCapteurs4Transmission1)
                                                        : etapeTransmi == EtatEtape.reussie
                                                          ? Text(AppLocalizations.of(context)!.initCapteurs4Transmission2)
                                                          : etapeTransmi == EtatEtape.echec
                                                            ? Text(AppLocalizations.of(context)!.initCapteurs4Transmission3)
                                                            : Text(AppLocalizations.of(context)!.initCapteurs4Transmission4)
                                                  ],
                                                );
                                              }
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ),
                          ]
                        );
                      }
                  });
                }  
              }
            )
        )),
      ],
    ));
  }
}