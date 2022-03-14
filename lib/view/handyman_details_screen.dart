import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

import 'package:flutter_master/widgets/avatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';

import 'screens.dart';

class HandymanDetailScreen extends StatefulWidget {
  static const String routeName = '/handyman_detail';

  static late UserModel? userModel;

  const HandymanDetailScreen({Key? key}) : super(key: key);
  static Route route(UserModel user) {
    userModel = user;
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return const HandymanDetailScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<HandymanDetailScreen> createState() => _HandymanDetailScreenState();
}

class _HandymanDetailScreenState extends State<HandymanDetailScreen> {
  late HandymanModel handymanModel;
  late NavigatorState _navigator;
  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = [];
    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launch(launchUri.toString());
    }

    if (HandymanDetailScreen.userModel is HandymanModel &&
        (HandymanDetailScreen.userModel as HandymanModel).urlToGallery !=
            null) {
      imageSliders = (HandymanDetailScreen.userModel as HandymanModel)
          .urlToGallery!
          .map((item) => Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        PhotoView(imageProvider: NetworkImage(item)),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ))
          .toList();
    }
    handymanModel = HandymanDetailScreen.userModel as HandymanModel;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
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
                                avatarUrl: handymanModel.avatarUrl,
                                onTap: () {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 22.0),
                                child: Text(handymanModel.displayName!,
                                    style: const TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(handymanModel.service!,
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
                                            style: const TextStyle(
                                                color: textColor,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Godine iskustva",
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
                                            style: const TextStyle(
                                                color: textColor,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Početna cena (RSD)",
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
                                            style: const TextStyle(
                                                color: textColor,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold)),
                                        Text("Srednja ocena",
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
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 42.0),
                    child: Column(children: [
                      const Text("O meni:",
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 19.0)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, top: 30, bottom: 24),
                        child: Text(
                            //cr provjeriti za null
                            handymanModel.description!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: textColor, fontSize: 15)),
                      ),
                      if (imageSliders.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            initialPage: 2,
                            autoPlay: true,
                          ),
                          items: imageSliders,
                        ),
                    ]),
                  )),
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
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: RaisedButton(
                        textColor: textColor,
                        color: appBarColor,
                        onPressed: () {
                          // Respond to button press
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _navigator
                                .push(
                                  ReviewsScreen.route(handymanModel),
                                )
                                .then((value) => setState(() {
                                      // refresh state of Page1
                                    }));
                          });
                        },
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 2, bottom: 2),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        WidgetsBinding.instance
                                            ?.addPostFrameCallback((_) {
                                          _navigator.pushNamed(
                                              ReviewsScreen.routeName,
                                              arguments: handymanModel);
                                        });
                                      },
                                      child: const Text("Recenzije:  ",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black)),
                                    ),
                                    Text(
                                        handymanModel.averageReviews != null
                                            ? handymanModel.averageReviews!
                                                .toStringAsFixed(2)
                                            : "0.0",
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold)),
                                    handymanModel.numberOfReviews != null
                                        ? Text(
                                            " (${handymanModel.numberOfReviews})",
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold))
                                        : const Text(""),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      size: 17,
                                      color: orange,
                                    ),
                                  ],
                                )),
                            const SizedBox(width: 15),
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
                                        children: const [
                                          Icon(Icons.phone),
                                          Text('Nazovi',
                                              style: TextStyle(fontSize: 15.0))
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
        ));
  }
}
