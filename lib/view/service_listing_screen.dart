import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/handyman_details_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

class ServiceListingScreen extends StatelessWidget {
  static const String routeName = '/service_listing';
  static String choosenService = '';
  static Route route(String service) {
    choosenService = service;
    return MaterialPageRoute(
        builder: (_) => ServiceListingScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service listing'),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .where("role", isEqualTo: "Handyman")
              .where("location",
                  isEqualTo:
                      locator.get<UserController>().currentUser?.location)
              .where("service", isEqualTo: choosenService)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: (snapshot.data as QuerySnapshot).docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds =
                          (snapshot.data as QuerySnapshot).docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, HandymanDetailScreen.routeName,
                              arguments: ds);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ds['avatarUrl'] != null
                                    ? Image.network(
                                        ds['avatarUrl'],
                                        height: 90,
                                        width: 90,
                                      )
                                    : const Image(
                                        image: AssetImage(
                                            'assets/logo/LogoMakr-4NVCFS.png'),
                                        height: 90,
                                        width: 90,
                                      ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds['username'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(height: 3),
                                  if (ds['phoneNumber'] != null)
                                    Text(ds['phoneNumber']),
                                  Text(ds['email'])
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Container();
              }
            } else {
              return Container();
            }
            // var email = (snapshot.data as QuerySnapshot).docs[0]['email'];
          }),
    );
  }
}
