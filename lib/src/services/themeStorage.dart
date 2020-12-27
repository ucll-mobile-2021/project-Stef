import 'package:shared_preferences/shared_preferences.dart';

Future<String> getThemeFromLocalStorage() async {
  SharedPreferences local = await SharedPreferences.getInstance();
  return local.getString('theme');
}

void setThemeInLocalStorage(String value) async {
  SharedPreferences local = await SharedPreferences.getInstance();
  local.setString('theme', value);
}
