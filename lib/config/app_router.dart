import 'package:flutter/material.dart';
import 'package:flutter_master/screens/filter/filter_screen.dart';
import 'package:flutter_master/screens/screens.dart';
import 'package:flutter_master/screens/service_details/service_details_screen.dart';
import 'package:flutter_master/screens/service_listing/service_listing_screen.dart';

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
      case ChatScreen.routeName:
        return ChatScreen.route();
      case ChatsListingScreen.routeName:
        return ChatsListingScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
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
