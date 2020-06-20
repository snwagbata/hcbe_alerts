import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/models.dart' show DistressMessage, Distress;
import 'package:hcbe_alerts/ui/components/components.dart'
    show AlertMessage, AlertDetailChip;
import 'package:hcbe_alerts/ui/map_ui.dart';
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
                    //Disabled until google_maps_flutter reaches stability
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MapUI(alert: alertDetail),
                      ),
                    );*/

                    final availableMaps = await MapLauncher.installedMaps;
                    await availableMaps.first.showMarker(
                      coords: Coords(alertDetail.location?.latitude,
                          alertDetail.location?.longitude),
                      title: _getDistressName(alertDetail.distressType),
                      description: _getDistressName(alertDetail.distressType),
                    );
                  },
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
                  child: Image.asset("assets/images/location.png",
                      fit: BoxFit.fill),
                ),
          SizedBox(height: 14),
          Wrap(
            spacing: 8.0,
            runSpacing: -8.0,
            children: <Widget>[
              StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(alertDetail.triggeredBy)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return AlertDetailChip(
                      Icons.person,
                      "Triggered by: ${snapshot.data.data['name']} (1101)", //number right next to name is user room number
                    );
                  }
                  return Container();
                },
              ),
              AlertDetailChip(
                Icons.event,
                "Activated: ${_getFormattedDate(alertDetail.timeTriggered.toDate())}",
              ),
              if (!alertDetail.active)
                AlertDetailChip(
                  Icons.event_available,
                  'Resolved: ${_getFormattedDate(alertDetail.timeResolved.toDate())}',
                ),
            ],
          ),
          SizedBox(height: 24),
          //Messages section begin
          Text(
            "Messages",
            style: Theme.of(context).textTheme.headline6,
          ),
          StreamBuilder(
            stream: Firestore.instance
                .collection("alertMessages")
                .where("alertId", isEqualTo: alertDetail.distressId)
                .orderBy("timestamp")
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text("There are no messages for this alert."),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return AlertMessage(
                    message: DistressMessage.fromDocument(
                      snapshot.data?.documents[index],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
