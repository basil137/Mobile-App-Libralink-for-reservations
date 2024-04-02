import 'package:shared_preferences/shared_preferences.dart';

class SetPref{
  static void setpref(String name, id) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setString("userName", name);
    sharedpref.setString("userId", id);
  }

}
