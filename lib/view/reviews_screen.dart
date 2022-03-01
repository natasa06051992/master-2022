import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/cubit/push_notification_service.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/review_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quick_feedback/quick_feedback.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsScreen extends StatefulWidget {
  static const String routeName = '/reviews';

  static List<HandymanModel> handymanModels = [];
  static Route route(HandymanModel handyman) {
    handymanModels.add(handyman);
    return MaterialPageRoute(
        builder: (_) => ReviewsScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void dispose() {
    ReviewsScreen.handymanModels.clear();
    // TODO: implement dispose
    super.dispose();
  }

  bool isMore = false;
  List<double> ratings = [];
  void _showFeedback(context) {
    showDialog(
      context: context,
      builder: (context) {
        return QuickFeedback(
          title: 'Leave a feedback',
          showTextBox: true,
          textBoxHint: 'Share your feedback',
          submitText: 'SUBMIT',
          onSubmitCallback: (feedback) {
            if (feedback["rating"] != null &&
                !ReviewsScreen.handymanModels[0].reviews!.any((element) =>
                    element.idReviewer ==
                    locator.get<UserController>().currentUser!.uid)) {
              var user = locator.get<UserController>().currentUser;
              locator.get<UserController>().addReview(feedback["rating"],
                  feedback["feedback"], ReviewsScreen.handymanModels[0]);
              if (user!.uid == ReviewsScreen.handymanModels[0].uid) {
                setState(() {});
                locator
                    .get<FCMNotificationService>()
                    .sendNotificationToSpecificUser(
                        "Dobio si ocenu!",
                        "Korisnik ${user!.displayName} te ocenio!",
                        ReviewsScreen.handymanModels[0].token!);
              }
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("User has already given feedback!"),
                ));
            }
            setState(() {});
            Navigator.of(context).pop();
          },
          askLaterText: 'ASK LATER',
          onAskLaterCallback: () {
            print('Do something on ask later click');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("reviews")
                .doc(ReviewsScreen.handymanModels[0].uid)
                .collection("review")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  ReviewsScreen.handymanModels[0].clearReviews();
                  ReviewsScreen.handymanModels[0].averageReviews = 0;
                  ratings.clear();
                  ReviewsScreen.handymanModels[0]
                      .addReviews((snapshot.data as QuerySnapshot).docs);

                  if (ReviewsScreen.handymanModels[0].reviews!.length > 0) {
                    ReviewsScreen.handymanModels[0].averageReviews =
                        ReviewsScreen.handymanModels[0].reviews!
                                .map((e) => e.rating)
                                .reduce((a, b) => a + b) /
                            ReviewsScreen.handymanModels[0].reviews!.length;

                    var one = 1 / (snapshot.data as QuerySnapshot).docs.length;

                    for (int i = 0; i < 5; i++) {
                      var rating = one *
                          ReviewsScreen.handymanModels[0].reviews!
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
                      padding: EdgeInsets.symmetric(
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
                                              .handymanModels[0].averageReviews
                                              ?.toStringAsFixed(2) ??
                                          "0.0",
                                      style: TextStyle(fontSize: 48.0),
                                    ),
                                    TextSpan(
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
                                        .handymanModels[0].averageReviews ??
                                    0.0,
                                size: 28.0,
                                color: Colors.orange,
                                borderColor: Colors.orange,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "${ReviewsScreen.handymanModels[0].reviews?.length} Reviews",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          Container(
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
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    SizedBox(width: 4.0),
                                    Icon(Icons.star, color: Colors.orange),
                                    SizedBox(width: 8.0),
                                    LinearPercentIndicator(
                                      lineHeight: 6.0,
                                      // linearStrokeCap: LinearStrokeCap.roundAll,
                                      width: MediaQuery.of(context).size.width /
                                          2.8,
                                      animation: true,
                                      animationDuration: 2500,
                                      percent: ratings[index],
                                      progressColor: Colors.orange,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () => _showFeedback(context),
                      child: Text(
                        'Add feedback',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: (snapshot.data as QuerySnapshot).docs.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds =
                              (snapshot.data as QuerySnapshot).docs[index];
                          return ReviewUI(
                            image: ReviewsScreen
                                .handymanModels[0].reviews![index].image,
                            name: ReviewsScreen
                                .handymanModels[0].reviews![index].name,
                            date: ReviewsScreen
                                .handymanModels[0].reviews![index].date,
                            comment: ReviewsScreen
                                .handymanModels[0].reviews![index].comment,
                            rating: ReviewsScreen
                                .handymanModels[0].reviews![index].rating,
                            onTap: () => setState(() {
                              isMore = !isMore;
                            }),
                            isLess: isMore,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
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
