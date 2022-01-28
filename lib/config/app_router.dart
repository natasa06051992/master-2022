import 'package:flutter/material.dart';
import 'package:flutter_master/screens/choose_service/choose_service_screen.dart';
import 'package:flutter_master/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_master/screens/profile/profile_screen.dart';
import 'package:flutter_master/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case HomeScreen.routeName:
        return HomeScreen.route();
      case LocationScreen.routeName:
        return LocationScreen.route();
      case FilterScreen.routeName:
        return FilterScreen.route();
      case ServiceDetailScreen.routeName:
        return ServiceDetailScreen.route();
      case ServiceListingScreen.routeName:
        return ServiceListingScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case OnBoardingScreen.routeName:
        return OnBoardingScreen.route();
      case RoleScreen.routeName:
        return RoleScreen.route();
      case ChooseServiceScreen.routeName:
        return ChooseServiceScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
