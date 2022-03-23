import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/services/connectivity.dart';
import 'package:flutter_master/services/firebase_firestore_repo.dart';
import 'package:flutter_master/services/storage_repo.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/category.dart';
import 'package:flutter_master/model/reviewModel.dart';
import 'package:flutter_master/model/user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserController {
  UserModel? _currentUser;
  List<Category>? _features = [];
  final StorageRepo _storageRepo = locator.get<StorageRepo>();
  final FirebaseFirestoreRepo _firebaseFirestoreRepo =
      locator.get<FirebaseFirestoreRepo>();

  Future<void> initUser(UserModel? userModel) async {
    _currentUser = userModel;
  }

  Future<void> initCategories() async {
    _features = await getCategories();
  }

  UserModel? get currentUser => _currentUser;
  List<Category>? get features => _features;
  Future<void> uploadProfilePicture(File image) async {
    await _storageRepo.uploadProfileImage(image, _currentUser!).then((value) {
      _currentUser!.avatarUrl = value;
      _firebaseFirestoreRepo.updateAvatarUrl(_currentUser!);
    });
  }

  void updateDisplayName(String text) {
    _currentUser!.displayName = text;
    _firebaseFirestoreRepo.updateDisplayName(text);
  }

  void updateService(String text) {
    if (_currentUser is HandymanModel) {
      (_currentUser as HandymanModel).service = text;
      _firebaseFirestoreRepo.updateService(_currentUser!, text);
    }
  }

  void updateLocation(String text) {
    _currentUser!.location = text;
    _firebaseFirestoreRepo.updateLocation(_currentUser!, text);
  }

  void addReview(rating, feedback, HandymanModel user) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy hh:mm');
    var review = ReviewModel(
        image: _currentUser?.avatarUrl,
        name: _currentUser?.displayName,
        rating: rating,
        date: formatter.format(DateTime.now()),
        comment: feedback,
        idReviewer: _currentUser!.uid);
    user.addReview(review);
    _firebaseFirestoreRepo.addReviewToFirestore(
        user.uid, review, _currentUser!.uid);

    var averageReview =
        user.reviews!.map((e) => e.rating).reduce((a, b) => a + b) /
            user.reviews!.length;
    user.averageReviews = averageReview;
    user.numberOfReviews = user.reviews!.length;
    _firebaseFirestoreRepo.updateAverageReviews(user.uid, averageReview);
    _firebaseFirestoreRepo.updateNumberOfReviews(
        user.uid, user.reviews!.length);
  }

  void updatePhoneNumber(String text) {
    _currentUser!.phoneNumber = text;
    _firebaseFirestoreRepo.updatePhoneNumber(_currentUser!, text);
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? getHandymanByService(
      String choosenService) {
    _firebaseFirestoreRepo.getHandymanByService(choosenService);
  }

  void updateDescription(String text) {
    (_currentUser! as HandymanModel).description = text;
    _firebaseFirestoreRepo.updateDescription(_currentUser!);
  }

  void updateStartingCost(int cost) {
    (_currentUser! as HandymanModel).startingPrice = cost;
    _firebaseFirestoreRepo.updateStartingCost(_currentUser!);
    calculate(currentUser!.location, (_currentUser! as HandymanModel).service!);
  }

  void updateYearsInBusiness(int years) {
    (_currentUser! as HandymanModel).yearsInBusiness = years;
    _firebaseFirestoreRepo.updateYearsInBusiness(_currentUser!);
  }

  uploadFiles(List<File> images) async {
    await _storageRepo
        .uploadImagesFeaturedProjects(images, _currentUser!)
        .then((value) {
      (_currentUser! as HandymanModel).urlToGallery?.addAll(value!);
      _firebaseFirestoreRepo.updateUrlToGallery(_currentUser!);
    });
  }

  Future<List<ReviewModel>?> getReviews(HandymanModel handymanModel) async {
    return await _firebaseFirestoreRepo.getReviews(handymanModel);
  }

  void addNewProject(String selectedService, String description, String title) {
    _firebaseFirestoreRepo.addNewProject(
        selectedService, description, title, currentUser);
  }

  Future<List<Category>?> getCategories() async {
    return await _firebaseFirestoreRepo.getCategories();
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    return await _firebaseFirestoreRepo.getUser(uid);
  }

  Future<void> deleteProject(String id) async {
    (currentUser as CustomerModel)
        .projects
        .removeWhere((element) => element == id);
    await _firebaseFirestoreRepo.deleteProject(id, currentUser);
  }

  calculate(String location, String service) async {
    return await _firebaseFirestoreRepo.calculate(location, service);
  }

  bool checkForInternetConnection(BuildContext buildContext) {
    return Provider.of<ConnectivityProvider>(buildContext).isOnline;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> handymansWithMostReviews(
      choosenService) {
    return _firebaseFirestoreRepo.handymansWithMostReviews(choosenService);
  }
}
