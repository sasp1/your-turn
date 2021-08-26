

import 'package:flutter/material.dart';
import 'package:your_turn/screens/TurnScreen.dart';
import 'package:your_turn/screens/chooseNameScreen.dart';
import 'package:your_turn/screens/splashScreen.dart';

class AppRoutes {
  static const chooseNameScreen = '/choose-name-screen';
  static const splashScreen = '/splash-screen';
  static const homeScreen = '/home';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.chooseNameScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChooseNameScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.splashScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.homeScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => TurnScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
      // TODO: Throw
        return null;
    }
  }
}