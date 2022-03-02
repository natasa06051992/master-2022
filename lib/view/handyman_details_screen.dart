import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/reviews_screen.dart';

import 'package:flutter_master/widgets/avatar.dart';
import 'package:flutter_master/widgets/photo_album.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class HandymanDetailScreen extends StatefulWidget {
  static const String routeName = '/handyman_detail';

  static late UserModel? userModel;
  static Route route(UserModel user) {
    userModel = user;
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
  void dispose() {
    HandymanDetailScreen.userModel = null;

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launch(launchUri.toString());
    }

    handymanModel = HandymanDetailScreen.userModel as HandymanModel;
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      child: Stack(
                    children: <Widget>[
                      SafeArea(
                        bottom: false,
                        right: false,
                        left: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Column(
                            children: [
                              Avatar(
                                avatarUrl: handymanModel!.avatarUrl ?? null,
                                onTap: () {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Text(handymanModel!.displayName!,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(handymanModel!.service!,
                                    style: TextStyle(
                                        color: textColor.withOpacity(0.85),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, left: 42, right: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //cr dodati provjeru da li je null
                                        Text(
                                            handymanModel.yearsInBusiness!
                                                .toString(),
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Years in businees",
                                            style: TextStyle(
                                                color:
                                                    textColor.withOpacity(0.8),
                                                fontSize: 12.0))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            handymanModel.startingPrice
                                                .toString(),
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Starting price (RSD)",
                                            style: TextStyle(
                                                color:
                                                    textColor.withOpacity(0.8),
                                                fontSize: 12.0))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            handymanModel.averageReviews
                                                .toString(),
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Average review",
                                            style: TextStyle(
                                                color:
                                                    textColor.withOpacity(0.8),
                                                fontSize: 12.0))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 42.0),
                    child: Column(children: [
                      Text("About me",
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, top: 30, bottom: 24),
                        child: Text(
                            //cr provjeriti za null
                            handymanModel.description!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textColor)),
                      ),
                      PhotoAlbum(imgArray: handymanModel.urlToGallery!),
                    ]),
                  ))),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RaisedButton(
                        textColor: textColor,
                        //color: labelColor,
                        onPressed: () {
                          // Respond to button press
                          Navigator.pushNamed(context, ReviewsScreen.routeName,
                              arguments: handymanModel);
                        },
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 10,
                                    bottom: 10),
                                child: Text("Reviews:",
                                    style: TextStyle(fontSize: 13.0))),
                            Text(
                              handymanModel.averageReviews != null
                                  ? handymanModel.averageReviews!
                                      .toStringAsFixed(2)
                                  : "0.0",
                            ),
                            handymanModel.numberOfReviews != null
                                ? Text(" (${handymanModel.numberOfReviews})")
                                : Text(""),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ReviewsScreen.routeName,
                                    arguments: handymanModel);
                              },
                              icon: Icon(
                                Icons.star,
                                size: 17,
                                color: purple,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  handymanModel.phoneNumber != null
                                      ? _makePhoneCall(
                                          handymanModel.phoneNumber!)
                                      : null;
                                },
                                child: handymanModel.phoneNumber == null
                                    ? null
                                    : Row(
                                        children: [
                                          Icon(Icons.mic),
                                          Text('Call')
                                        ],
                                      ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
        //  Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Column(children: [
        //     Row(
        //       children: [
        //         ClipRRect(
        //           borderRadius: BorderRadius.circular(30),
        //           child: handymanModel.avatarUrl != null
        //               ? Image.network(
        //                   handymanModel.avatarUrl!,
        //                   height: 110,
        //                   width: 110,
        //                 )
        //               : const Image(
        //                   image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
        //                   height: 110,
        //                   width: 110,
        //                 ),
        //         ),
        //         Text(
        //           handymanModel.displayName ?? "anonyms",
        //         ),
        //         SizedBox(
        //           width: 20,
        //         ),
        //         Row(
        //           children: [
        //             Text(
        //               handymanModel.averageReviews != null
        //                   ? handymanModel.averageReviews!.toStringAsFixed(2)
        //                   : "",
        //             ),
        //             IconButton(
        //               onPressed: () {
        //                 Navigator.pushNamed(context, ReviewsScreen.routeName,
        //                     arguments: handymanModel);
        //               },
        //               icon: Icon(Icons.star, size: 17),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ]),
        // )

        );
  }
}
