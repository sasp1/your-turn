import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_turn/models/timeSlot.dart';
import 'package:your_turn/models/user.dart';

class SharedPrefsHelper {
  final String _chosenNameKey = "chosenNameKey";
  final String _userIdKey = "userIdKey";
  final String _usersKey = "usersKey";

  const SharedPrefsHelper();

  Future<String> getChosenName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_chosenNameKey);
  }

  Future<void> setChosenName(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_chosenNameKey, name);
  }

  Future<String> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_userIdKey);
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userIdKey, userId);
  }

  Future<void> setUsers(List<User> users) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String usersJson = User.encodeUsers(users);


    await sharedPreferences.setString(_usersKey, usersJson);
  }

  Future<List<User>> getUsers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String usersJson = sharedPreferences.getString(_usersKey);

    List<User> users = User.decodeUsers(usersJson);
    return users;
  }

}
