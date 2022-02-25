import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/add_new_project.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

class CustomersProjects extends StatelessWidget {
  static const String routeName = '/customers_projects';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => CustomersProjects(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("projects")
              .where("uid",
                  isEqualTo: locator.get<UserController>().currentUser!.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                      return Center(
                          child: Card(
                        child: Text(
                          ds['title'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ));
                    });
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewProjectScreen.routeName);
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
