import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Future implementation
/// TODO: once google_maps_flutter reaches stable
/// will implement a full page google maps widget for handling the
/// display of alert location to admins
/// DISCONTINUED: 4/3/2020
/// Revisit: 10/7/2020
class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    Widget map = GoogleMap(
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(-7.122802, -34.858036),
        zoom: 15.5,
      ),
      onMapCreated: (GoogleMapController controller) async {
        mapController = controller;
        _controller.complete(controller);
      },
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
      ),
      body: map,
    );
  }
}