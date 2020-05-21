import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/distress.dart';
import 'package:hcbe_alerts/widgets/map_view.dart';
import 'package:hcbe_alerts/widgets/navigator.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

class AlertDetail extends StatelessWidget {
  final Distress alertDetail;

  AlertDetail({this.alertDetail});
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

  _getFormattedDate(DateTime now) {
    return DateFormat.yMd().add_jm().format(now);
  }

  String _getSignedUrl(String url, String apiKey) {
    String baseUrl = 'https://maps.googleapis.com';

    List<int> messageBytes = utf8.encode(url);
    List<int> key = base64.decode(base64.normalize(apiKey));
    Hmac hmac = new Hmac(sha1, key);
    Digest digest = hmac.convert(messageBytes);
    String signature = base64.encode(digest.bytes);
    return (baseUrl +
        url +
        "&signature=" +
        signature.replaceAll('+', '-').replaceAll('/', '_'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getDistressName(alertDetail.distressType)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: <Widget>[
          SizedBox(height: 7),
          (alertDetail.location != null)
              ? GestureDetector(
                  onTap: () async {
                    pushPage(
                      context,
                      MapView(
                        latitude: alertDetail.location?.latitude,
                        longitude: alertDetail.location?.longitude,
                      ),
                    );

                    /**
                    final availableMaps = await MapLauncher.installedMaps;
                    await availableMaps.first.showMarker(
                      coords: Coords(alertDetail.location?.latitude,
                          alertDetail.location?.longitude),
                      title: _getDistressName(alertDetail.distressType),
                      description: alertDetail.message,
                    ); 
                    */
                  },
                  //use shimmer to show that content is supposed to be here is loading
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                        _getSignedUrl(
                            '/maps/api/staticmap?size=600x350&zoom=18&markers=color:blue%7Clabel:!%7C${alertDetail?.location?.latitude},${alertDetail?.location?.longitude}&key=AIzaSyAN8Q05ewqwVLNtjQcY7vVR0Uz1cGyHwpQ',
                            'aXru0BA5NRlWCILLfOi3BzgwJ5s='),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }, fit: BoxFit.fill),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    //TODO: local storage of location not found image to increase picture loading time
                      "https://via.placeholder.com/600x350/000000/FFFFFF/?text=Location+Not+Reported",
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }, fit: BoxFit.fill),
                ),

                
        ],
      ),
    );
  }
}
