import 'package:flutter/services.dart';
import 'package:hcbe_alerts/helpers/user_exception.dart';

class ErrorHandler{

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'Account does not exist.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Password is invalid.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'The email address is already in use by another account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else if (e is UserException) {
      switch (e.code) {
        case 'SCHOOL_CODE_INVALID':
          return 'School code is invalid.';
          break;
        case 'UNVERIFIED_EMAIL':
          return 'Please verify your email to sign in.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}