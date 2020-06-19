import 'package:cloud_firestore/cloud_firestore.dart';

class DistressMessage {
  final String uid;
  final String distressId;
  final String message;

  DistressMessage({this.uid, this.distressId, this.message});

  factory DistressMessage.fromJson(Map<String, dynamic> json) =>
      DistressMessage(
        uid: json['uid'],
        distressId: json['alertId'] ?? '',
        message: json['message'] ?? '',
      );

  factory DistressMessage.fromDocument(DocumentSnapshot snapshot) {
    return DistressMessage.fromJson(snapshot.data);
  }

  Map<String, dynamic> toJson() =>
      {"uid": uid, "alertId": distressId, "message": message};
}
