import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_master/model/reviewModel.dart';

import '../config/constants.dart';

class UserModel {
  late String uid;
  String? displayName;
  String? avatarUrl;
  String? email;
  String? phoneNumber;
  late String location;
  late String role;
  late String? token;

  UserModel(this.uid,
      {this.displayName,
      this.avatarUrl,
      this.email,
      this.phoneNumber,
      required this.location,
      required this.role,
      this.token,
      s});

  void setAvatarUrl(String url) {
    avatarUrl = avatarUrl;
  }

  void setToken(String token) {
    this.token = token;
  }

  UserModel.fromDocumentSnapshot(Map<String, dynamic> snapshot) {
    uid = snapshot['uid'];
    displayName = snapshot['username'];
    email = snapshot['email'];
    phoneNumber = snapshot['phoneNumber'];
    location = snapshot['location'];
    avatarUrl = snapshot['avatarUrl'];
    role = snapshot['role'];
    token = snapshot['token'];
  }
}

class HandymanModel extends UserModel {
  String? service;
  double? stars;
  int? startingPrice;
  String? description;
  int? yearsInBusiness;
  double? averageReviews;
  List<String>? urlToGallery = [];
  List<ReviewModel>? reviews;
  int? numberOfReviews = 0;
  HandymanModel(
      String uid,
      displayName,
      email,
      phoneNumber,
      this.service,
      String selectedLocation,
      String? url,
      this.averageReviews,
      this.numberOfReviews,
      String? token,
      this.urlToGallery,
      allowNotifications)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation,
            avatarUrl: url,
            role: Constants.role[0],
            token: token) {
    reviews = [];
  }

  HandymanModel.fromDocumentSnapshot(Map<String, dynamic> snapshot)
      : super.fromDocumentSnapshot(snapshot) {
    service = snapshot['service'];
    averageReviews = snapshot['averageReviews'];
    numberOfReviews = snapshot['numberOfReviews'];
    urlToGallery = snapshot['urlToGallery'] != null
        ? List.from(snapshot['urlToGallery'])
        : [];
    yearsInBusiness = snapshot['yearsInBusiness'];
    startingPrice = snapshot['startingPrice'];
    description = snapshot['description'];
    reviews = <ReviewModel>[];
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
      reviews?.add(ReviewModel.fromDocumentSnapshot(review));
    }
  }

  clearReviews() {
    reviews!.clear();
  }
}

class CustomerModel extends UserModel {
  List<String> projects = [];
  CustomerModel(
      String uid,
      displayName,
      email,
      phoneNumber,
      String selectedLocation,
      String? url,
      String? token,
      List<String> projects,
      allowNotifications)
      : super(
          uid,
          displayName: displayName,
          email: email,
          phoneNumber: phoneNumber,
          location: selectedLocation,
          avatarUrl: url,
          role: Constants.role[1],
          token: token,
        );
  CustomerModel.fromDocumentSnapshot(Map<String, dynamic> snapshot)
      : super.fromDocumentSnapshot(snapshot) {
    projects =
        snapshot['projects'] != null ? List.from(snapshot['projects']) : [];
  }
  addProject(String project) {
    projects.add(project);
  }
}
