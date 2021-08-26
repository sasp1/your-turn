

import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier{
  int _selectedUser;
  int get selectedUser => _selectedUser;

  void selectUser(int user){
    _selectedUser = user;
    notifyListeners();
  }

}