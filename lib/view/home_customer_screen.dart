import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/app_bar.dart';
import 'package:flutter_master/widgets/feature_item.dart';
import 'package:flutter_master/widgets/search_widget.dart';

import '../model/category.dart';

class HomeCustomerScreen extends StatefulWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return HomeCustomerScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  String query = '';

  late List<Category> searchedFeatures = [];
  late List<Category> features = [];
  late bool isInitCalled = false;
  late TextEditingController controller;
  @override
  void initState() {
    locator.get<UserController>().initCategories();
    features = locator.get<UserController>().features ?? [];
    searchedFeatures = features;
    controller = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  void searchCategory(String query) {
    searchedFeatures = query == "" || query == " "
        ? features
        : features
            .where((element) => element.name.toLowerCase().contains(query))
            .toList();

    setState(() {
      this.query = query;
    });
  }

  Widget buildSearch() {
    return SearchWidget(
        text: query, hintText: 'Potraži', onChanged: searchCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(context, 'Početna'),
        body: Column(
          children: [
            buildSearch(),
            CarouselSlider(
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
                  height: MediaQuery.of(context).viewInsets.bottom != 0
                      ? MediaQuery.of(context).size.height * 0.45
                      : MediaQuery.of(context).size.height * 0.8,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction:
                      MediaQuery.of(context).viewInsets.bottom != 0 ? 1 : 0.5,
                ),
                items: List.generate(
                    searchedFeatures.length,
                    (index) => FeatureItem(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ServiceListingScreen.routeName,
                              arguments: searchedFeatures[index].name);
                        },
                        data: searchedFeatures[index]))),
          ],
        ));
  }
}
