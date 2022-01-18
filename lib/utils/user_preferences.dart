import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/model/user.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyUser = 'user';
  static const myUser = User(
    imagePath:
        'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80%27',
    name: 'Sarah Joe',
    email: 'sarah.abs@gmail.com',
    about:
        'Hi,I am Sarah.I like reading fantasy books because it’s an escape from reality. Reality can get frustrating sometimes. Don’t you think a world with magic would be a lot more fun? It’s a bit refreshing to see something different from time to time and fantasy books tend to be imaginative.',
    isDarkMode: false,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences?.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences?.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
