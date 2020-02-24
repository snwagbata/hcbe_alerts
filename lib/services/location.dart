import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart';

class LocationInit {
  static initLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await LocationPermissions().checkPermissionStatus();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await LocationPermissions().requestPermissions();
      ;
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
