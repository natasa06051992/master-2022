import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/project.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/add_new_project.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/app_bar.dart';
import 'package:flutter_master/widgets/mini_card_project.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomersProjects extends StatefulWidget {
  static const String routeName = '/customers_projects';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => CustomersProjects(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<CustomersProjects> createState() => _CustomersProjectsState();
}

class _CustomersProjectsState extends State<CustomersProjects> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: locator.get<UserController>().currentUser != null &&
                locator.get<UserController>().currentUser is CustomerModel
            ? AppBar(title: const Text('Projects'))
            : buildAppBar(context, 'Projects'),
        body: FutureBuilder(
            future: getProjects(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const CircularProgressIndicator(),
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
                                //child: projectWidget(context, ds),
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
                  Navigator.pushNamed(context, AddNewProjectScreen.routeName);
                },
                backgroundColor: Colors.purple,
                child: const Icon(Icons.add),
              )
            : null);
  }

  Center projectWidget(BuildContext context, DocumentSnapshot<Object?> ds) {
    var project = Project.fromDocumentSnapshot(ds as Map<String, dynamic>);
    return Center(
        child: Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: project.imageOfCustomer != null
                  ? Image.network(
                      project.imageOfCustomer!,
                      height: 90,
                      width: 90,
                    )
                  : const Image(
                      image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
                      height: 90,
                      width: 90,
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  project.title,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  project.description,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  project.date,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 30),
                if (locator.get<UserController>().currentUser is HandymanModel)
                  ElevatedButton(
                      onPressed: () {
                        project.phoneNumber != null
                            ? _makePhoneCall(project.phoneNumber!)
                            : null;
                      },
                      child: project.phoneNumber == null
                          ? null
                          : Row(
                              children: [Icon(Icons.phone), Text('Call')],
                            ))
              ],
            ),
          ],
        ),
      ),
    ));
  }

  getProjects() {
    if (locator.get<UserController>().currentUser is CustomerModel) {
      return FirebaseFirestore.instance
          .collection("projects")
          .where("uid",
              isEqualTo: locator.get<UserController>().currentUser!.uid)
          .get();
    } else {
      return FirebaseFirestore.instance.collection("projects").get();
    }
  }
}
