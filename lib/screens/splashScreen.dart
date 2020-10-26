

import 'package:flutter/material.dart';
import 'package:your_turn/services/rest.dart';
import 'package:your_turn/services/sharedPrefsHelper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPrefsHelper _sharedPrefsHelper;
  RestService _restService;

  @override
  void initState() {
    super.initState();
    _sharedPrefsHelper = SharedPrefsHelper();
    _restService = RestService();
    _setup();
  }

  void _setup() async {
    String jwt = await _sharedPrefsHelper.getUserId();

    if (jwt == null || jwt.isEmpty)
      jwt = await _restService.signUp("");

    _sharedPrefsHelper.setUserId(jwt);

    Navigator.of(context).pushReplacementNamed("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      ),
    );
  }
}
