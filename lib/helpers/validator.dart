class Validator {
  static String email(String value) {
    Pattern pattern =
        r'^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(hcbe)\.net$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid HCBE email address.';
    else
      return null;
  }

  static String password(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }

  static String name(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter your name.';
    else
      return null;
  }

//check if school code exists before procedding with sign up
  static String school(String value) {
    Pattern pattern = r'^.{4,}$';
    RegExp regex = new RegExp(pattern);
    if (value.length == 0)
      return 'Please enter your school code';
    else if (!regex.hasMatch(value))
      return 'School code must be at least 4 characters.';
    return null;
  }
}
