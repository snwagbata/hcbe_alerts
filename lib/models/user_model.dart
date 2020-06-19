/// User Model
/// 
/// Firestore rules will prevent the editing of 
/// the userType field by non admin user
/// Might change if we migrate to a different database,
///
class UserModel {
  String uid;
  String email;
  String name;
  String school;
  bool textAlerts;
  String photoUrl;
  String userType;

  UserModel({this.uid, this.email, this.name, this.school, this.textAlerts, this.photoUrl, this.userType});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['userId'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      school: data['school'] ?? '',
      textAlerts: data['textAlerts'] ?? false,
      photoUrl: data['photoUrl'] ?? '',
      userType: data['userType'] ?? 'teacher',
    );
  }

  Map<String, dynamic> toJson() =>
      {"userId": uid, "email": email, "name": name, "school": school, "textAlerts": textAlerts, "photoUrl": photoUrl, "userType": userType};
}
