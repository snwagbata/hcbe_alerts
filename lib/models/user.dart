import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String name;
  String email;
  String school;
  String userType;
  

  User({
    this.userId,
    this.name,
    this.email,
    this.school,
    this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        school: json["school"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
        "school": school,
        "userType": userType,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }

  String getUserId()
  {
    return this.userId;
  }

  String userSchoolId()
  {
    return this.school;
  }
}