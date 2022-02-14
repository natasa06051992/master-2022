import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_feedback/quick_feedback.dart';

import 'package:flutter_master/widgets/avatar.dart';

class HandymanDetailScreen extends StatelessWidget {
  static const String routeName = '/service_detail';
  static late DocumentSnapshot documentSnapshot;
  static Route route(DocumentSnapshot snapshot) {
    documentSnapshot = snapshot;
    return MaterialPageRoute(
        builder: (_) => HandymanDetailScreen(),
        settings: RouteSettings(name: routeName));
  }

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
            print('$feedback'); // map { rating: 2, feedback: 'some feedback' }
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
          title: Text('Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: [
                Avatar(
                  avatarUrl: documentSnapshot['avatarUrl'] ?? null,
                  onTap: () {},
                ),
                Text(
                  documentSnapshot['username'],
                ),
              ],
            ),
            FlatButton(
              onPressed: () => _showFeedback(context),
              child: Text('Add feedback'),
            ),
          ]),
        ));
  }
}
