import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polyleaks/bluetooth/bluetooth_manager.dart';
import 'package:polyleaks/components/bottom_sheet_details.dart';
import 'package:polyleaks/database/polyleaks_database.dart';
import 'package:polyleaks/pages/accueil/capteur_slot_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';


class VueMaps extends StatefulWidget {
  const VueMaps({super.key});

  @override
  State<VueMaps> createState() => _VueMapsState();
}

class _VueMapsState extends State<VueMaps> {
  LatLng _cameraPosition = const LatLng(47.217246, -1.553691);
  double _cameraZoom = 11.5;
  double _cameraBearing = 0;
  double _cameraTilt = 0;
  bool gpsTracking = false;
  bool gpsActive = false;
  bool gpsPermission = false;
  bool cameraAuto = false;
  late StreamSubscription<Position> positionStream;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    gpsPermission = context.read<CapteurStateNotifier>().gpsPermission;
    loadMarkers();
  }

  @override
  void dispose() {
    // si position stream est actif, le fermer
    if (gpsTracking) {
      positionStream.cancel();
    }
    super.dispose();
  }

  void loadMarkers() async {
    List<Map<String, dynamic>> capteurs = await PolyleaksDatabase().getLocalisationCapteurs();

    setState(() {
      _markers = capteurs.map((capteur) => Marker(
        markerId: MarkerId(capteur["nom"].toString()),
        position: LatLng(capteur["localisation"][0], capteur["localisation"][1]),
        // Ajoutez d'autres propriétés du marqueur si nécessaire
        onTap: () {
          showBottomSheetDetails(context, vueMaps: false, vueSlot: true, nom: capteur["nom"]);
        },
      )).toSet();
    });

  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  @override
  Widget build(BuildContext context) {

    // reset bearing and tilt function
    void resetCamera() async {
      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _cameraPosition,
          zoom: _cameraZoom,
          bearing: 0,
          tilt: 0,
        ),
      ));
      setState(() {
        cameraAuto = true;
      });
    }

    void followPosition() async {
      final capteurState = Provider.of<CapteurStateNotifier>(context, listen: false);
      final GoogleMapController mapController = await _controller.future;

      if (await BluetoothManager().isLocationActivated(context, maps: true) != true) {
        setState(() {
          gpsTracking = false;
          gpsActive = false;
          gpsPermission = false;
        });
        return;
      }

      if (!gpsActive) {
        positionStream = Geolocator.getPositionStream().listen(
          (Position? position) {
            if (position != null) {
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 17,
                  bearing: _cameraBearing,
                ),
              ));
              setState(() {
                cameraAuto = true;
              });
            }
          });

        setState(() {
          gpsTracking = true;
          gpsActive = true;
          gpsPermission = true;
        });

        capteurState.setGpsPermission(true);
      } else {
        positionStream.cancel();
        setState(() {
          gpsActive = false;
          gpsTracking = false;
        });
      }


    }


    return Scaffold(
      body: Stack(
        children: <Widget>[

          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _cameraPosition,
              zoom: _cameraZoom,
            ),
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: gpsActive,
            myLocationButtonEnabled: false,

            markers: _markers,

            onCameraIdle: () {
              setState(() {
                if (cameraAuto) {
                  cameraAuto = false;
                }
              });
            },

            onCameraMove: (CameraPosition position) {
              setState(() {
                // si le suivi de position est activé, et que ce n'est pas un mouvement automatique
                if (gpsTracking && !cameraAuto){
                  gpsTracking = false;
                  positionStream.cancel();
                }
                _cameraPosition = position.target;
                _cameraZoom = position.zoom;
                _cameraBearing = position.bearing;
                _cameraTilt = position.tilt;
              });
            },
          ),


          // navigation tools
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 54,
                width: 245,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => resetCamera(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Transform(
                              alignment: Alignment.center,
                              // tilt the compass icon to match the camera tilt
                              transform: Matrix4.rotationX(_cameraTilt*-3.145926/180),
                              child: Transform.rotate(
                                angle: _cameraBearing*-3.145926/180,
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    "assets/compass.svg",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => followPosition(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              !gpsPermission ? Icons.gps_off : gpsTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
                              color: gpsActive ? Colors.blue : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          )
        ]
      ),
    );
  }
}
