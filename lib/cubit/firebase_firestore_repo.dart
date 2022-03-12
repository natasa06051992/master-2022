import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/category.dart';
import 'package:flutter_master/model/reviewModel.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FirebaseFirestoreRepo {
  String usersCollection = 'users';

  addUserToFirebase(UserModel user) {
    String role = user is HandymanModel ? 'Handyman' : 'Customer';
    final Map<String, dynamic> data = {
      'uid': user.uid,
      'username': user.displayName,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'phoneNumber': user.phoneNumber,
      'location': user.location,
      'role': role,
      'token': user.token
    };

    addHandymanDetails(user, data);
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .set(data);
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
        .collection(usersCollection)
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
        .collection(usersCollection)
        .doc(user.uid)
        .update(data);
  }

  void updateService(UserModel user, String text) {
    final Map<String, dynamic> data = {'service': text};
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .update(data);
  }

  Future<String> getLocation(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    return snap['location'];
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .get();
    return snap.exists ? snap.data() : null;
  }

  Future<String> getRole(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    return snap['role'];
  }

  Future<String> getService(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    return snap['service'];
  }

  Future<double> getAverageReviews(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    return snap['averageReviews'];
  }

  Future<int> getNumOfReviews(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    return snap['numberOfReviews'];
  }

  Future<String> getPhoneNumber(User user) async {
    var snap = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.uid)
        .get();
    return snap['phoneNumber'];
  }

  checkIfUserIsSignedUp(String uid) async {
    var usersRef =
        FirebaseFirestore.instance.collection(usersCollection).doc(uid);
    bool isSignedUp = false;
    await usersRef.get().then((docSnapshot) => {
          if (docSnapshot.exists) {isSignedUp = true} else {isSignedUp = false}
        });
    return isSignedUp;
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? getHandymanByService(
      String choosenService) async {
    var handymans = await FirebaseFirestore.instance
        .collection(usersCollection)
        .where("role", isEqualTo: "Handyman")
        .where("service", isEqualTo: choosenService)
        .get();
    return handymans;
  }

  Future<void> updateAvatarUrl(UserModel userModel) async {
    final Map<String, dynamic> data = {'avatarUrl': userModel.avatarUrl};
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userModel.uid)
        .update(data);
    final Map<String, dynamic> dataProjects = {
      'imageOfCustomer': userModel.avatarUrl
    };
    List<String> projects = await getProjects(userModel.uid);
    projects.forEach((element) {
      FirebaseFirestore.instance
          .collection('projects')
          .doc(element)
          .update(dataProjects);
    });
  }

  void updateDescription(UserModel userModel) {
    final Map<String, dynamic> data = {
      'description': (userModel as HandymanModel).description
    };
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateStartingCost(UserModel userModel) {
    final Map<String, dynamic> data = {
      'startingPrice': (userModel as HandymanModel).startingPrice
    };
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateYearsInBusiness(UserModel userModel) {
    final Map<String, dynamic> data = {
      'yearsInBusiness': (userModel as HandymanModel).yearsInBusiness
    };
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userModel.uid)
        .update(data);
  }

  void updateUrlToGallery(UserModel userModel) {
    final Map<String, dynamic> data = {
      'urlToGallery': (userModel as HandymanModel).urlToGallery
    };
    FirebaseFirestore.instance
        .collection(usersCollection)
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
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .update(data);
  }

  void updateNumberOfReviews(String uid, int length) {
    final Map<String, dynamic> data = {'numberOfReviews': length};
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .update(data);
  }

  Future<List<ReviewModel>?> getReviews(HandymanModel handymanModel) async {
    QuerySnapshot firebaseReviews = await FirebaseFirestore.instance
        .collection("reviews")
        .doc(handymanModel.uid)
        .collection("review")
        .get();
    List<ReviewModel> result = [];
    for (var doc in firebaseReviews.docs) {
      result.add(ReviewModel.fromDocumentSnapshot(doc));
    }
    return result;
    //cr
  }

  Future<List<Category>?> getCategories() async {
    QuerySnapshot firebaseCategories =
        await FirebaseFirestore.instance.collection("category").get();
    List<Category> result = [];
    for (var doc in firebaseCategories.docs) {
      result.add(Category.fromDocumentSnapshot(doc));
    }
    return result;
  }

  Future<List<String>> getProjects(String uid) async {
    QuerySnapshot firebaseProjects = await FirebaseFirestore.instance
        .collection("projects")
        .where('uid', isEqualTo: uid)
        .get();
    List<String> result = [];
    for (var doc in firebaseProjects.docs) {
      result.add(doc.reference.id);
    }
    return result;
  }

  Future<List<String>> getUrlsToGallery(User user) async {
    QuerySnapshot firebaseUrl = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: user.uid)
        .get();
    List<String> result = [];
    firebaseUrl.docs.forEach((doc) {
      result.add(doc.reference.id);
    });
    return result;
  }

  void updateToken(String? token, String uid) {
    final Map<String, dynamic> data = {'token': token};
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .update(data);
  }

  Future<void> deleteProject(String id, UserModel? currentUser) async {
    final Map<String, dynamic> dataProjects = {
      'projects': (currentUser as CustomerModel).projects
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update(dataProjects);
    return FirebaseFirestore.instance.collection('projects').doc(id).delete();
  }

  calculate(String location, String service) async {
    QuerySnapshot<Map<String, dynamic>> listOfHandymans =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Handyman')
            .where('service', isEqualTo: service)
            .where('location', isEqualTo: location)
            .get();

    List<double> result = [];
    listOfHandymans.docs.forEach((doc) {
      var starting = doc['startingPrice'];
      if (starting != 0) {
        result.add(starting.toDouble());
      }
    });
    var avrg = result.reduce((a, b) => a + b) / result.length;

    DocumentReference docRef =
        FirebaseFirestore.instance.collection("category").doc(service);

    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic>? docData = docSnapshot.data() as Map<String, dynamic>?;

    List<Map<String, dynamic>> services =
        (docData!["pricePerLocation"] as List<dynamic>)
            .map((price) => Map<String, dynamic>.from(price))
            .toList();

    for (int index = 0; index < services.length; index++) {
      Map<String, dynamic> chatroom = services[index];
      if (chatroom["location"] == location) {
        chatroom["price"] = avrg.toString();
      }
    }

    await docRef.update({"pricePerLocation": services});
  }
}
