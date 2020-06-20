import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcbe_alerts/helpers/user_exception.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:hcbe_alerts/models/models.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  // Firebase user a realtime stream
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser(FirebaseUser firebaseUser) {
    if (firebaseUser?.uid != null) {
      return _db
          .document('/users/${firebaseUser.uid}')
          .snapshots()
          .map((snapshot) => UserModel.fromMap(snapshot.data));
    }
    return null;
  }

  //Method to handle user sign in using email and password
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    if (!user.isEmailVerified) {
      throw UserException(code: "UNVERIFIED_EMAIL");
    }
    return user;
  }

  // User registration using email and password
  Future<bool> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        //send verifcation email
        result.user.sendEmailVerification();

        print('uID: ' + result.user.uid);
        print('email: ' + result.user.email);

        //get photo url from gravatar if user has one
        Gravatar gravatar = Gravatar(email);
        String gravatarUrl = gravatar.imageUrl(
          size: 200,
          defaultImage: GravatarImage.retro,
          rating: GravatarRating.pg,
          fileExtension: true,
        );

        //create the new user object
        UserModel _newUser = UserModel(
          uid: result.user.uid,
          email: result.user.email,
          name: name,
          photoUrl: gravatarUrl,
          userType: 'teacher',
        );
        //update the user in firestore
        _updateUserFirestore(_newUser, result.user);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //handles updating the user when updating profile
  Future<bool> updateUser(
      UserModel user, String oldEmail, String password) async {
    bool _result = false;
    await _auth
        .signInWithEmailAndPassword(email: oldEmail, password: password)
        .then((_firebaseUser) {
      _firebaseUser.user.updateEmail(user.email);
      _updateUserFirestore(user, _firebaseUser.user);
      _result = true;
    });
    return _result;
  }

  //updates the firestore users collection
  void _updateUserFirestore(UserModel user, FirebaseUser firebaseUser) {
    _db
        .document('/users/${firebaseUser.uid}')
        .setData(user.toJson(), merge: true);
  }

  void updateTextAlerts(String uid, bool textAlerts) {
    Firestore.instance.collection("users").document(uid).updateData(
      {
        "textAlerts": textAlerts,
      },
    );
  }

  //password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkSchoolExist(String schoolId) async {
    var doc = await Firestore.instance.document("schools/$schoolId").get();
    if (doc.exists) return true;
    throw UserException(code: 'SCHOOL_CODE_INVALID');
  }

  Future<UserModel> getUserFirestore(String userId) async {
    if (userId != null) {
      return Firestore.instance
          .collection('users')
          .document(userId)
          .get()
          .then((documentSnapshot) => UserModel.fromMap(documentSnapshot.data));
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}

/* Not currently used functions for managing 
google, apple and anonymous signin 
https://github.com/fireship-io/flutter-firebase-quizapp-course


final GoogleSignIn _googleSignIn = GoogleSignIn();
// Determine if Apple Signin is available on device
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<FirebaseUser> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple
      }

      final AuthCredential credential =
          OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      // Update user data
      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Sign in with Google
  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      Gravatar gravatar = Gravatar(user.email);
      String gravatarUrl = gravatar.imageUrl(
        size: 200,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true,
      );
      UserModel _newUser = UserModel(
          uid: user.uid,
          email: user.email,
          name: user.displayName,
          photoUrl: gravatarUrl);
      // _auth.signInWithEmailAndPassword(email: email, password: password);
      UserData(collection: 'users').upsert(_newUser.toJson());

      // Update user data
      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Anonymous Firebase login
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;

    updateUserData(user);
    return user;
  }

    /// Updates the User's data in Firestore on each new login
  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);
    return reportRef.setData({'uid': user.uid, 'lastActivity': DateTime.now()},
        merge: true);
  }
  */
