

import 'package:flutter/material.dart';
import 'package:your_turn/rest.dart';
import 'package:your_turn/sharedPrefsHelper.dart';

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
    String jwt = await _sharedPrefsHelper.getJwt();

    if (jwt == null || jwt.isEmpty)
      jwt = await _restService.signUp();

    _sharedPrefsHelper.setJwt(jwt);

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
