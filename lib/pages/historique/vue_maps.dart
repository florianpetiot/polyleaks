import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VueMaps extends StatefulWidget {
  const VueMaps({super.key});

  @override
  State<VueMaps> createState() => _VueMapsState();
}

class _VueMapsState extends State<VueMaps> {
  final LatLng _center = const LatLng(47.217246, -1.553691);

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.5,
            ),
            zoomControlsEnabled: false,
            compassEnabled: false,
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
                    ClipRRect(
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
                          child: const Icon(
                            Icons.north,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),

                    ClipRRect(
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
                          child: const Icon(
                            Icons.gps_fixed_rounded,
                            color: Colors.blue,
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
