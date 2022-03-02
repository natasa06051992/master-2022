import 'package:flutter/material.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/add_new_project.dart';
import 'package:flutter_master/view/add_pictures_featured_projects.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeCustomerScreen.routeName:
        return HomeCustomerScreen.route();

      case HandymanDetailScreen.routeName:
        final args = settings.arguments as UserModel;
        return HandymanDetailScreen.route(args);
      case ServiceListingScreen.routeName:
        final args = settings.arguments as String;
        return ServiceListingScreen.route(args);
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
      case ReviewsScreen.routeName:
        final args = settings.arguments as HandymanModel;
        return ReviewsScreen.route(args);
      case AddNewProjectScreen.routeName:
        return AddNewProjectScreen.route();
      case CustomersProjects.routeName:
        return CustomersProjects.route();
      case AddPicturesFeaturedProjects.routeName:
        return AddPicturesFeaturedProjects.route();
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
