import 'package:flutter/material.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/widgets/app_bar.dart';
import 'package:flutter_master/widgets/search_widget.dart';

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
  List<String> categories = Constants.services;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Home'),
      body: Column(
        children: [
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, i) {
                return InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.pushNamed(context, ServiceListingScreen.routeName,
                        arguments: Constants.services[i]);
                  },
                  child: ListTile(
                    title: Text("${Constants.services[i]}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return SearchWidget(
        text: query, hintText: 'Search category', onChanged: searchCategory);
  }

  void searchCategory(String query) {
    categories = Constants.services.where((element) {
      final catrs = element.toString().toLowerCase();
      return catrs.contains(query);
    }).toList();
    setState(() {
      this.query = query;
      this.categories = categories;
    });
  }
}
