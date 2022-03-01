import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/widgets/app_bar.dart';
import 'package:flutter_master/widgets/feature_item.dart';
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

  List features = [
    {
      "id": 100,
      "name": "House cleaning",
      "image":
          "https://bookdirtbusters.com/wp-content/uploads/2020/10/Cleaning-supplies.png",
      "price": "\$110.00",
    },
    {
      "id": 101,
      "name": "Handyman",
      "image":
          "https://i2.wp.com/movingtips.wpengine.com/wp-content/uploads/2020/06/handyman.jpg?w=336&ssl=1",
      "price": "\$155.00",
    },
    {
      "id": 102,
      "name": "Plumber",
      "image":
          "https://lp-seotool.s3.us-west-2.amazonaws.com/task_attachments/NJYIZcSAE5ODTImqJirgg7kunj18e3wK1598976088.jpg",
      "price": "\$65.00",
    },
    {
      "id": 103,
      "name": "Other",
      "image":
          "https://5.imimg.com/data5/GD/SP/GLADMIN-6143571/building-maintenance-500x500.jpg",
      "price": "\$80.00",
    },
  ];

  void searchCategory(String query) {
    features = features
        .where((element) =>
            element['name'].toString().toLowerCase().contains(query))
        .toList();

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
      appBar: buildAppBar(context, 'Home'),
      body: Column(
        children: [
          buildSearch(),
          CarouselSlider(
              options: CarouselOptions(
                scrollDirection: Axis.vertical,
                height: MediaQuery.of(context).viewInsets.bottom != 0
                    ? MediaQuery.of(context).size.height * 0.4
                    : MediaQuery.of(context).size.height * 0.78,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction:
                    MediaQuery.of(context).viewInsets.bottom != 0 ? 1 : 0.5,
              ),
              items: List.generate(
                  features.length,
                  (index) => FeatureItem(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ServiceListingScreen.routeName,
                            arguments: features[index]["name"]);
                      },
                      data: features[index]))),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: categories.length,
          //     itemBuilder: (context, i) {
          //       return InkWell(
          //         splashColor: Colors.blue.withAlpha(30),
          //         onTap: () {
          //           Navigator.pushNamed(context, ServiceListingScreen.routeName,
          //               arguments: Constants.services[i]);
          //         },
          //         child: ListTile(
          //           title: Text("${Constants.services[i]}"),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
