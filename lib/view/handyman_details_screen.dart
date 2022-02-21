import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/reviews_screen.dart';

import 'package:flutter_master/widgets/avatar.dart';

class HandymanDetailScreen extends StatefulWidget {
  static const String routeName = '/handyman_detail';

  static List<DocumentSnapshot> documentSnapshots = [];
  static Route route(DocumentSnapshot snapshot) {
    documentSnapshots.add(snapshot);
    return MaterialPageRoute(
        builder: (_) => HandymanDetailScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<HandymanDetailScreen> createState() => _HandymanDetailScreenState();
}

class _HandymanDetailScreenState extends State<HandymanDetailScreen> {
  late HandymanModel handymanModel;

  @override
  Widget build(BuildContext context) {
    handymanModel = HandymanModel.fromDocumentSnapshot(
        HandymanDetailScreen.documentSnapshots[0]);
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: [
                Avatar(
                  avatarUrl: handymanModel.avatarUrl ?? null,
                  onTap: () {},
                ),
                Text(
                  handymanModel.displayName ?? "anonyms",
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    Text(
                      handymanModel.averageReviews != null
                          ? handymanModel.averageReviews.toString()
                          : "",
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ReviewsScreen.routeName,
                            arguments: handymanModel);
                      },
                      icon: Icon(Icons.star, size: 17),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ));
  }
}
