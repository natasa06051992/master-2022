import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/constants.dart';
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
        builder: (_) => HomeCustomerScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  String query = '';

  late List<Category> searchedFeatures = [];
  late List<Category> features = [];

  void searchCategory(String query) {
    searchedFeatures = query != ""
        ? searchedFeatures
            .where((element) => element.name.toLowerCase().contains(query))
            .toList()
        : features;

    setState(() {
      this.query = query;
    });
  }

  Widget buildSearch() {
    return SearchWidget(
        text: query, hintText: 'Search category', onChanged: searchCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context, 'Home'),
      body: FutureBuilder(
          future: locator.get<UserController>().getCategories(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var list = snapshot.data;
                for (var snapshot in list) {
                  features.add(snapshot);
                }
                searchedFeatures = List<Category>.from(features);
                return Column(
                  children: [
                    buildSearch(),
                    CarouselSlider(
                        options: CarouselOptions(
                          scrollDirection: Axis.vertical,
                          height: MediaQuery.of(context).viewInsets.bottom != 0
                              ? MediaQuery.of(context).size.height * 0.45
                              : MediaQuery.of(context).size.height * 0.78,
                          enlargeCenterPage: true,
                          disableCenter: true,
                          viewportFraction:
                              MediaQuery.of(context).viewInsets.bottom != 0
                                  ? 1
                                  : 0.5,
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
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
  }
}
