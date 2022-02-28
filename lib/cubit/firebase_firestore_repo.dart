import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_master/model/reviewModel.dart';
import 'package:flutter_master/model/user.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
      'role': role,
      'token': user.token
    };

    addHandymanDetails(user, data);
    FirebaseFirestore.instance.collection(collection).doc(user.uid).set(data);
  }

  void addHandymanDetails(UserModel user, Map<String, dynamic> data) {
    if (user is HandymanModel) {
      data['service'] = user.service;
      data['description'] = user.description;
      data['startingPrice'] = user.startingPrice;
      data['yearsInBusiness'] = user.yearsInBusiness;
      data['averageReviews'] = user.averageReviews;
      data['numberOfReviews'] = user.numberOfReviews;
    }
  }

  void updatePhoneNumber(UserModel user, String text) async {
    final Map<String, dynamic> data = {'phoneNumber': text};
    FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .update(data);

    QuerySnapshot firebaseReviews = await FirebaseFirestore.instance
        .collection("projects")
        .where('uid', isEqualTo: user.uid)
        .get();

    firebaseReviews.docs.forEach((doc) {
      doc.reference.update(data);
    });
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUser(String uid) async {
    var snap =
        await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    return snap.exists ? snap : null;
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

  Future<double> getAverageReviews(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .get();
    return snap['averageReviews'];
  }

  Future<int> getNumOfReviews(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .get();
    return snap['numberOfReviews'];
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

  void addReviewToFirestore(
      String uid, ReviewModel review, String uidCustomer) {
    final Map<String, dynamic> data = {
      'comment': review.comment,
      'date': review.date,
      'image': review.image,
      'name': review.name,
      'rating': review.rating,
      'idReviewer': review.idReviewer
    };

    FirebaseFirestore.instance
        .collection("reviews")
        .doc(uid)
        .collection("review")
        .doc(uidCustomer)
        .set(data);
  }

  void addNewProject(String selectedService, String description, String title,
      UserModel? currentUser) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final Map<String, dynamic> data = {
      'uid': currentUser!.uid,
      'description': description,
      'service': selectedService,
      'date': formatter.format(DateTime.now()),
      'imageOfCustomer': currentUser!.avatarUrl,
      'name': currentUser!.displayName,
      'location': currentUser!.location,
      'phoneNumber': currentUser!.phoneNumber,
      'title': title
    };
    var uuid = Uuid();
    String id = uuid.v4();
    (currentUser as CustomerModel).addProject(id);
    FirebaseFirestore.instance.collection("projects").doc(id).set(data);
    final Map<String, dynamic> dataProjects = {
      'projects': (currentUser as CustomerModel).projects
    };
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .update(dataProjects);
  }

  void updateAverageReviews(String uid, double averageReview) {
    final Map<String, dynamic> data = {'averageReviews': averageReview};
    FirebaseFirestore.instance.collection(collection).doc(uid).update(data);
  }

  void updateNumberOfReviews(String uid, int length) {
    final Map<String, dynamic> data = {'numberOfReviews': length};
    FirebaseFirestore.instance.collection(collection).doc(uid).update(data);
  }

  Future<List<ReviewModel>?> getReviews(HandymanModel handymanModel) async {
    QuerySnapshot firebaseReviews = await FirebaseFirestore.instance
        .collection("reviews")
        .doc(handymanModel.uid)
        .collection("review")
        .get();
    List<ReviewModel> result = [];
    firebaseReviews.docs.forEach((doc) {
      var data = doc.data();
    });
    return result;
  }

  Future<List<String>> getProjects(User user) async {
    QuerySnapshot firebaseReviews = await FirebaseFirestore.instance
        .collection("projects")
        .where('uid', isEqualTo: user.uid)
        .get();
    List<String> result = [];
    firebaseReviews.docs.forEach((doc) {
      var data = doc.data();
    });
    return result;
  }

  Future<List<String>> getUrlsToGallery(User user) async {
    QuerySnapshot firebaseReviews = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: user.uid)
        .get();
    List<String> result = [];
    firebaseReviews.docs.forEach((doc) {
      var data = doc.data();
    });
    return result;
  }

  Future<void> deleteProject(String id, UserModel? currentUser) async {
    final Map<String, dynamic> dataProjects = {
      'projects': (currentUser as CustomerModel).projects
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update(dataProjects);
    return FirebaseFirestore.instance.collection('projects').doc(id).delete();
  }
}
