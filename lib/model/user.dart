import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_master/model/reviewModel.dart';

class UserModel {
  late String uid;
  String? displayName;
  String? avatarUrl;
  String? email;
  String? phoneNumber;
  late String location;
  late String role;

  bool isHandyman = false;

  UserModel(this.uid,
      {this.displayName,
      this.avatarUrl,
      this.email,
      this.phoneNumber,
      required this.location,
      required this.role});

  void setAvatarUrl(String url) {
    avatarUrl = avatarUrl;
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    displayName = snapshot['username'];
    email = snapshot['email'];
    phoneNumber = snapshot['phoneNumber'];
    location = snapshot['location'];
    email = snapshot['email'];
    phoneNumber = snapshot['phoneNumber'];
    avatarUrl = snapshot['avatarUrl'];
    role = snapshot['role'];
  }
}

class HandymanModel extends UserModel {
  String? service;
  double? stars;
  int? startingPrice;
  String? description;
  int? yearsInBusiness;
  double? averageReviews;
  List<String>? urlToGallery;
  List<ReviewModel>? reviews;
  HandymanModel(String uid, displayName, email, phoneNumber, service,
      String selectedLocation, String? url, double? averageReviews)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation,
            avatarUrl: url,
            role: "Handyman") {
    averageReviews = averageReviews;
    service = service;
    urlToGallery = <String>[];
    reviews = <ReviewModel>[];
  }

  HandymanModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : super.fromDocumentSnapshot(snapshot) {
    service = snapshot['service'];
    averageReviews = snapshot['averageReviews'].toDouble();
    role = snapshot['role'];
    service = service;
    urlToGallery = <String>[];
    reviews = <ReviewModel>[];
  }
  void setAverageReviews(double averageReviews) {
    averageReviews = averageReviews;
  }

  addReview(ReviewModel review) {
    reviews?.add(review);
  }

  addToGallery(String url) {
    urlToGallery?.add(url);
  }

  void setStartingPrice(int price) {
    startingPrice = price;
  }

  void setYearsInBusiness(int years) {
    yearsInBusiness = years;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setService(String service) {
    this.service = service;
  }

  void setStars(double stars) {
    this.stars = stars;
  }

  void addReviews(List<QueryDocumentSnapshot<Object?>> docs) {
    for (var review in docs) {
      this.reviews?.add(ReviewModel.fromDocumentSnapshot(review));
    }
  }

  clearReviews() {
    this.reviews!.clear();
  }
}

class CustomerModel extends UserModel {
  CustomerModel(String uid, displayName, email, phoneNumber,
      String selectedLocation, String? url)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation,
            avatarUrl: url,
            role: "Customer");
}
