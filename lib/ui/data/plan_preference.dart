import 'package:shared_preferences/shared_preferences.dart';

Future<void> setInitFirst(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('initFirst', value);
}

Future<bool> initFirst() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('initFirst') ?? true;
}
