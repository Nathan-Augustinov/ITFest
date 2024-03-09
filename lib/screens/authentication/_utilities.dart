import 'package:shared_preferences/shared_preferences.dart';

class AuthUtilities {
  void saveUserEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userEmail', email);
  }

  Future<String> getLoggedUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString('userEmail');
    return email.toString();
  }
}
