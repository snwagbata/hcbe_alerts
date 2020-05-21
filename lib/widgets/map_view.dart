import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Future implementation
/// TODO: once google_maps_flutter reaches stable
/// will implement a full page google maps widget for handling the
/// display of alert location to admins
/// DISCONTINUED: 4/3/2020
/// Revisit: 10/7/2020
class MapView extends StatefulWidget {
  final double longitude;
  final double latitude;

  const MapView({this.latitude, this.longitude});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) async{
    setState(() {
      _mapController = controller;
    });   
    moveToPosition();
  }

  void moveToPosition() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(widget.latitude, widget.longitude), zoom: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: const LatLng(0, 0),
          zoom: 11.0,
        ),
      ),
    );
  }
}
