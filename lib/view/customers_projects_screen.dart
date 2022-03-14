import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';

import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/project.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/add_new_project.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/app_bar.dart';
import 'package:flutter_master/widgets/mini_card_project.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screens.dart';

class CustomersProjects extends StatefulWidget {
  static const String routeName = '/customers_projects';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return CustomersProjects();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<CustomersProjects> createState() => _CustomersProjectsState();
}

class _CustomersProjectsState extends State<CustomersProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: locator.get<UserController>().currentUser != null &&
                locator.get<UserController>().currentUser is CustomerModel
            ? AppBar(title: const Text('Oglasi'))
            : buildAppBar(context, 'Oglasi'),
        body: FutureBuilder(
            future: getProjects(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var list = (snapshot.data as QuerySnapshot).docs;
                  return ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = list[index];

                        var project = Project.fromDocumentSnapshot(
                            ds.data() as Map<String, dynamic>);
                        return locator.get<UserController>().currentUser
                                is HandymanModel
                            ? MiniCardProject(
                                project: project,
                              )
                            : Dismissible(
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    size: 40.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (_) async {
                                  await locator
                                      .get<UserController>()
                                      .deleteProject(list[index].id);
                                  setState(() {
                                    list.removeAt(index);
                                  });
                                },
                                confirmDismiss: (direction) {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Potvrda'),
                                          content: const Text(
                                              'Da li zelite da obrisete projekat?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Da'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('Ne'),
                                            )
                                          ],
                                        );
                                      });
                                },
                                direction: DismissDirection.endToStart,
                                key: Key(index.toString()),
                                child: MiniCardProject(
                                  project: project,
                                ),
                              );
                      });
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            }),
        floatingActionButton: locator.get<UserController>().currentUser
                is CustomerModel
            ? FloatingActionButton(
                onPressed: () {
                  if (locator.get<UserController>().currentUser!.phoneNumber ==
                      null) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content:
                            Text('Dodaj broj telefona pre dodavanja projekta!'),
                      ));
                  } else {
                    Navigator.pushNamed(context, AddNewProjectScreen.routeName);
                  }
                },
                backgroundColor: purple,
                child: const Icon(Icons.add),
              )
            : null);
  }

  getProjects() {
    if (locator.get<UserController>().currentUser is CustomerModel) {
      return FirebaseFirestore.instance
          .collection("projects")
          .where("uid",
              isEqualTo: locator.get<UserController>().currentUser!.uid)
          .get();
    } else {
      return FirebaseFirestore.instance
          .collection("projects")
          .where("service",
              isEqualTo:
                  (locator.get<UserController>().currentUser! as HandymanModel)
                      .service)
          .get();
    }
  }
}
