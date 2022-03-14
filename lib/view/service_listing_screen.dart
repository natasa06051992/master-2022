import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/mini_card.dart';

import 'no_internet.dart';

class ServiceListingScreen extends StatefulWidget {
  static const String routeName = '/service_listing';
  static String choosenService = '';
  static Route route(String service) {
    choosenService = service;
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return ServiceListingScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

var _selectedSort = Constants.sortBy[0];

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [
                const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.compare_arrows, size: 20)),
                DropdownButton(
                  value: _selectedSort,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSort = newValue.toString();
                    });
                  },
                  items: Constants.sortBy.map((_selectedSort) {
                    return DropdownMenuItem(
                      child: Text(_selectedSort),
                      value: _selectedSort,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListOfHandyman(
                  choosenService: ServiceListingScreen.choosenService)),
        ],
      ),
    );
  }
}

class ListOfHandyman extends StatelessWidget {
  const ListOfHandyman({
    Key? key,
    required this.choosenService,
  }) : super(key: key);

  final String choosenService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getHandymans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                (snapshot.data as QuerySnapshot).docs.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: (snapshot.data as QuerySnapshot).docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return MiniCard(
                      userModel: HandymanModel.fromDocumentSnapshot(
                          (snapshot.data as QuerySnapshot).docs[index].data()
                              as Map<String, dynamic>));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10.0,
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Trenutno nemamo majstora iz ove kategorije!'),
              );
            }
          } else {
            return Container();
          }
          // var email = (snapshot.data as QuerySnapshot).docs[0]['email'];
        });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getHandymans() {
    if (_selectedSort == Constants.sortBy[3]) //najpopularnije
    {
      return FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: Constants.role[0])
          .where("location",
              isEqualTo: locator.get<UserController>().currentUser?.location)
          .where("service", isEqualTo: choosenService)
          .orderBy('numberOfReviews', descending: true)
          .get();
    } else if (_selectedSort == Constants.sortBy[2]) //najveca ocena
    {
      return FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: Constants.role[0])
          .where("location",
              isEqualTo: locator.get<UserController>().currentUser?.location)
          .where("service", isEqualTo: choosenService)
          .orderBy('averageReviews', descending: true)
          .get();
    } else if (_selectedSort == Constants.sortBy[1]) //skuplje
    {
      return FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: Constants.role[0])
          .where("location",
              isEqualTo: locator.get<UserController>().currentUser?.location)
          .where("service", isEqualTo: choosenService)
          .orderBy('startingPrice', descending: true)
          .get();
    } else if (_selectedSort == Constants.sortBy[0]) //jeftinije
    {
      return FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: Constants.role[0])
          .where("location",
              isEqualTo: locator.get<UserController>().currentUser?.location)
          .where("service", isEqualTo: choosenService)
          .orderBy('startingPrice', descending: false)
          .get();
    } else {
      return FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: Constants.role[0])
          .where("location",
              isEqualTo: locator.get<UserController>().currentUser?.location)
          .where("service", isEqualTo: choosenService)
          .get();
    }
  }
}
