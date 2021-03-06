import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quick_feedback/quick_feedback.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:flutter_master/services/push_notification_service.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';

import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/app_bar.dart';
import 'package:flutter_master/widgets/review_widget.dart';

import 'no_internet.dart';

class ReviewsScreen extends StatefulWidget {
  static const String routeName = '/reviews';

  static HandymanModel? handymanModel;
  static Route route(HandymanModel handyman) {
    handymanModel = handyman;
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return ReviewsScreen();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late UserModel user;
  @override
  void initState() {
    user = locator.get<UserController>().currentUser!;
    // TODO: implement initState
    super.initState();
  }

  bool isMore = false;
  List<double> ratings = [];
  void _showFeedback(context) {
    showDialog(
      context: context,
      builder: (context) {
        return QuickFeedback(
          title: 'Ocenite majstora',
          showTextBox: true,
          textBoxHint: 'Napišite recenziju',
          submitText: 'Pošalji',
          onSubmitCallback: (feedback) {
            if (feedback["rating"] != null && userHaventAlreadyGivenReview()) {
              locator.get<UserController>().addReview(feedback["rating"],
                  feedback["feedback"], ReviewsScreen.handymanModel!);
              if (user!.uid != ReviewsScreen.handymanModel!.uid) {
                setState(() {});
                locator.get<NotificationService>().sendPushMessage(
                    "Dobio si ocenu!",
                    "Korisnik ${user!.displayName} te ocenio!",
                    ReviewsScreen.handymanModel!.token!);
              }
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text("Korisnik je već dao ocenu!"),
                ));
            }
            setState(() {});
            Navigator.of(context).pop();
          },
          askLaterText: 'Kasnije',
          onAskLaterCallback: () {},
        );
      },
    );
  }

  bool userHaventAlreadyGivenReview() {
    return !ReviewsScreen.handymanModel!.reviews!.any((element) =>
        element.idReviewer == locator.get<UserController>().currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, 'Recenzije'),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("reviews")
                .doc(ReviewsScreen.handymanModel!.uid)
                .collection("review")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  ReviewsScreen.handymanModel!.clearReviews();
                  ReviewsScreen.handymanModel!.averageReviews = 0;
                  ratings.clear();
                  ReviewsScreen.handymanModel!
                      .addReviews((snapshot.data as QuerySnapshot).docs);

                  if (ReviewsScreen.handymanModel!.reviews!.isNotEmpty) {
                    ReviewsScreen.handymanModel!.averageReviews = ReviewsScreen
                            .handymanModel!.reviews!
                            .map((e) => e.rating)
                            .reduce((a, b) => a + b) /
                        ReviewsScreen.handymanModel!.reviews!.length;

                    var one = 1 / (snapshot.data as QuerySnapshot).docs.length;

                    for (int i = 0; i < 5; i++) {
                      var rating = one *
                          ReviewsScreen.handymanModel!.reviews!
                              .where((x) => x.rating == (i + 1))
                              .length;
                      ratings.add(rating);
                    }
                  } else {
                    for (int i = 0; i < 5; i++) {
                      ratings.add(0);
                    }
                  }

                  return Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ReviewsScreen
                                              .handymanModel!.averageReviews
                                              ?.toStringAsFixed(2) ??
                                          "0.0",
                                      style: const TextStyle(fontSize: 48.0),
                                    ),
                                    const TextSpan(
                                      text: "/5",
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SmoothStarRating(
                                isReadOnly: true,
                                starCount: 5,
                                rating: ReviewsScreen
                                        .handymanModel!.averageReviews ??
                                    0.0,
                                size: 22.0,
                                color: orange,
                                borderColor: orange,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                "${ReviewsScreen.handymanModel!.reviews?.length} recenzija",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 200.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Text(
                                      "${index + 1}",
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Icon(Icons.star, color: orange),
                                    const SizedBox(width: 8.0),
                                    LinearPercentIndicator(
                                      lineHeight: 6.0,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      animation: true,
                                      animationDuration: 2500,
                                      percent: ratings[index],
                                      progressColor: orange,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (locator.get<UserController>().currentUser
                        is CustomerModel)
                      FlatButton(
                        onPressed: () => _showFeedback(context),
                        child: const Text(
                          'Ostavi recenziju',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: (snapshot.data as QuerySnapshot).docs.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ReviewUI(
                            image: ReviewsScreen
                                .handymanModel!.reviews![index].image,
                            name: ReviewsScreen
                                .handymanModel!.reviews![index].name,
                            date: ReviewsScreen
                                .handymanModel!.reviews![index].date,
                            comment: ReviewsScreen
                                .handymanModel!.reviews![index].comment,
                            rating: ReviewsScreen
                                .handymanModel!.reviews![index].rating,
                            onTap: () => setState(() {
                              isMore = !isMore;
                            }),
                            isLess: isMore,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            thickness: 2.0,
                          );
                        },
                      ),
                    )
                  ]);
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            }));
  }
}
