import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  late String? image;
  late String? name;
  late int rating;
  late String date;
  late String comment;
  late String idReviewer;

  ReviewModel(
      {required this.image,
      required this.name,
      required this.rating,
      required this.date,
      required this.comment,
      required this.idReviewer});

  ReviewModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    image = snapshot['image'];
    name = snapshot['name'];
    rating = snapshot['rating'];
    date = snapshot['date'];
    comment = snapshot['comment'];
    idReviewer = snapshot['idReviewer'];
  }
}
