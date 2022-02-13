import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_master/model/user.dart';

class FirebaseFirestoreRepo {
  String collection = 'users';
  addUserToFirebase(UserModel user) {
    String role = user is HandymanModel ? 'Handyman' : 'Customer';
    final Map<String, dynamic> data = {
      'username': user.displayName,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'phoneNumber': user.phoneNumber,
      'location': user.location,
      'role': role
    };

    addService(user, data);
    FirebaseFirestore.instance.collection(collection).doc(user.uid).set(data);
  }

  void addService(UserModel user, Map<String, dynamic> data) {
    if (user is HandymanModel) {
      data['service'] = user.service;
      data['description'] = user.description;
      data['startingPrice'] = user.startingPrice;
      data['yearsInBusiness'] = user.yearsInBusiness;
    }
  }

  void updatePhoneNumber(UserModel user, String text) {
    final Map<String, dynamic> data = {'phoneNumber': text};
    FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .update(data)
        .then((value) => print('updateovan br'));
  }

  void updateLocation(UserModel user, String text) {
    final Map<String, dynamic> data = {'location': text};
    FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .update(data);
  }

  void updateService(UserModel user, String text) {
    final Map<String, dynamic> data = {'service': text};
    FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .update(data);
  }

  Future<String> getLocation(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .get();
    return snap['location'];
  }

  Future<String> getRole(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .get();
    return snap['role'];
  }

  Future<String> getService(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .get();
    return snap['service'];
  }

  checkIfUserIsSignedUp(String uid) async {
    var usersRef = FirebaseFirestore.instance.collection(collection).doc(uid);
    bool isSignedUp = false;
    await usersRef.get().then((docSnapshot) => {
          if (docSnapshot.exists) {isSignedUp = true} else {isSignedUp = false}
        });
    return isSignedUp;
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? getHandymanByService(
      String choosenService) async {
    var handymans = await FirebaseFirestore.instance
        .collection(collection)
        .where("role", isEqualTo: "Handyman")
        .where("service", isEqualTo: choosenService)
        .get();
    return handymans;
  }

  void updateAvatarUrl(UserModel userModel) {
    final Map<String, dynamic> data = {'avatarUrl': userModel.avatarUrl};
    FirebaseFirestore.instance
        .collection(collection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateDescription(UserModel userModel) {
    final Map<String, dynamic> data = {
      'description': (userModel as HandymanModel).description
    };
    FirebaseFirestore.instance
        .collection(collection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateStartingCost(UserModel userModel) {
    final Map<String, dynamic> data = {
      'startingPrice': (userModel as HandymanModel).startingPrice
    };
    FirebaseFirestore.instance
        .collection(collection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateYearsInBusiness(UserModel userModel) {
    final Map<String, dynamic> data = {
      'yearsInBusiness': (userModel as HandymanModel).yearsInBusiness
    };
    FirebaseFirestore.instance
        .collection(collection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateUrlToGallery(UserModel userModel) {
    final Map<String, dynamic> data = {
      'urlToGallery': (userModel as HandymanModel).urlToGallery
    };
    FirebaseFirestore.instance
        .collection(collection)
        .doc(userModel.uid)
        .update(data);
  }
}
