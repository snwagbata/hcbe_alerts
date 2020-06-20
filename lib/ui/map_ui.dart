import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcbe_alerts/models/distress.dart';

class MapUI extends StatefulWidget {
  final Distress alert;

  MapUI({this.alert});

  @override
  State<MapUI> createState() => MapUIState();
}

class MapUIState extends State<MapUI> {
  static String code;
  static double lat;
  static double long;
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    lat = widget.alert.location?.latitude;
    long = widget.alert.location?.longitude;
    code = _getDistressName(widget.alert.distressType);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getDistressName(String db) {
    switch (db) {
      case "red":
        return "Code Red";
        break;
      case "blue":
        return "Code Blue";
        break;
      case "intruder":
        return "Active Intruder";
        break;
      case "yellow":
        return "Code Yellow";
        break;
      default:
        return "Code Green";
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //https://github.com/flutter/flutter/issues/43721#issuecomment-551528822
    //required to apply padding correctly on Android
    //setState(() {});
  }

  static final CameraPosition _school = CameraPosition(
    bearing: 0,
    target: LatLng(lat, long),
    zoom: 19.151926040649414,
  );

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("id"),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: code),
      ),
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              /*
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 4.0,
              ),*/
              markers: _createMarker(),
              onMapCreated: _onMapCreated,
              initialCameraPosition: _school,
            ),
          ), /*
          Container(
            height: MediaQuery.of(context).size.height / 4.0,
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      code,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
