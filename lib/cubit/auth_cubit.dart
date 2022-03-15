import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_master/cubit/firebase_firestore_repo.dart';
import 'package:flutter_master/cubit/storage_repo.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/constants.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthDefault());
  static UserModel? userModel;
  // initalizing the instance for our facebook
  // google and firebase
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookSignIn = FacebookAuth.instance;

  // login method
  Future login(String email, String password) async {
    emit(const AuthLoginLoading());
    try {
      var firebaseUser = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = firebaseUser.user;

      // login success state
      if (user != null) {
        await createCurrentUser(user)
            .then((value) => emit(AuthLoginSuccess(user: user)));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginError(error: e.message!));
    }
  }

  linkEmailGoogle() async {
    List<String> providers = await firebaseAuth
        .fetchSignInMethodsForEmail(firebaseAuth.currentUser!.email!);

    User? existingUser = firebaseAuth.currentUser;
    if (existingUser == null || providers.contains("google.com")) return;

    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential gcredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await existingUser.linkWithCredential(gcredential);
    } catch (e) {
      print(e);
    }
  }

  Future googleAuth() async {
    emit(const AuthGoogleLoading());
    try {
      late GoogleSignInAccount? _googleUser;
      try {
        _googleUser = await googleSignIn.signIn();
      } on FirebaseAuthException catch (e) {
        emit(AuthGoogleError(error: e.toString()));
      }
      if (_googleUser == null) {
        emit(const AuthGoogleError());
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      bool isSigndUpUser = await locator
          .get<FirebaseFirestoreRepo>()
          .checkIfUserIsSignedUp(user!.uid);
      if (isSigndUpUser) {
        await createCurrentUser(user)
            .then((value) => emit(AuthGoogleSuccess(user: user)));
      } else {
        emit(const AuthGoogleError(error: "Korisnik nije napravio nalog!"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthGoogleError(error: e.toString()));
    }
  }

  Future<void> createCurrentUser(User user) async {
    String selectedRole =
        await locator.get<FirebaseFirestoreRepo>().getRole(user);

    await createUser(selectedRole);
  }

  Future<String?> getDownloadUrl(String uid) async {
    return await locator.get<StorageRepo>().getUserProfileImageUrl(uid);
  }

  // signup method
  Future signUp(
      String name,
      String password,
      String email,
      String selectedLocation,
      String selectedRole,
      String selectedService,
      bool isAlreadyCreatedAccount) async {
    emit(const AuthSignUpLoading());
    try {
      User? user;

      if (!isAlreadyCreatedAccount) {
        user = (await firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;
      } else {
        user = firebaseAuth.currentUser;
      }

      // if the user is not null
      if (user != null) {
        user
            .updateDisplayName(name)
            .then((value) => createNewUser(
                selectedLocation, selectedRole, selectedService, 0, 0, [], []))
            .then((value) =>
                locator.get<FirebaseFirestoreRepo>().addUserToFirebase(value))
            .then((value) => emit(const AuthSignUpSuccess()));
        linkEmailGoogle();
      }
    } on FirebaseAuthException catch (e) {
      firebaseAuth.currentUser?.delete();
      emit(AuthSignUpError(e.message));
    }
  }

  createNewUser(
      String selectedLocation,
      String selectedRole,
      String? selectedService,
      double? averageReviews,
      int? numOfReviewa,
      List<String> urlToGallery,
      List<String> projects) async {
    var firebaseUser = firebaseAuth.currentUser!;
    if (userModel == null && firebaseAuth.currentUser != null) {
      String? url = await getDownloadUrl(firebaseUser.uid);
      String? token = await FirebaseMessaging.instance.getToken();
      if (selectedRole.contains(Constants.role[0])) {
        userModel = HandymanModel(
            firebaseUser.uid,
            firebaseUser.displayName!,
            firebaseUser.email!,
            firebaseUser.phoneNumber,
            selectedService,
            selectedLocation,
            url,
            averageReviews,
            numOfReviewa,
            token,
            urlToGallery,
            true);
      } else {
        userModel = CustomerModel(
            firebaseUser.uid,
            firebaseUser.displayName!,
            firebaseUser.email!,
            firebaseUser.phoneNumber,
            selectedLocation,
            url,
            token,
            projects,
            true);
      }
    }
    locator.get<UserController>().initUser(userModel);
    return userModel;
  }

  // forgot password method
  Future forgotPassword(String email) async {
    emit(const AuthForgotPasswordLoading());
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      emit(const AuthForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthForgotPasswordError(e.message));
    }
  }

  // google auth

  Future facebookAuth() async {
    try {
      emit(const AuthFBLoading());
      final LoginResult result = await facebookSignIn.login();

      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          User? userCredential =
              (await firebaseAuth.signInWithCredential(facebookCredential))
                  .user;
          bool isSigndUpUser = await locator
              .get<FirebaseFirestoreRepo>()
              .checkIfUserIsSignedUp(userCredential!.uid);
          if (isSigndUpUser) {
            await createCurrentUser(userCredential);
            emit(AuthFBSuccess(user: userCredential));
          }
          return;

        case LoginStatus.failed:
          return emit(const AuthFBError());
        default:
          return emit(const AuthFBError());
      }
    } on FirebaseAuthException {
      emit(const AuthFBError());
      //throw e;
    }
  }

  Future logout() async {
    userModel = null;
    locator.get<UserController>().initUser(null);
    await firebaseAuth.signOut();
    emit(const AuthLogout());
  }

  createUser(
    String selectedRole,
  ) async {
    var firebaseUser = firebaseAuth.currentUser!;
    if (userModel == null && firebaseAuth.currentUser != null) {
      var userFromFirestore =
          await locator.get<UserController>().getUser(firebaseUser.uid);
      if (selectedRole.contains(Constants.role[0])) {
        userModel = HandymanModel.fromDocumentSnapshot(
            userFromFirestore as Map<String, dynamic>);
      } else {
        userModel = CustomerModel.fromDocumentSnapshot(
            userFromFirestore as Map<String, dynamic>);
      }
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && userModel!.token != token) {
        locator.get<FirebaseFirestoreRepo>().updateToken(token, userModel!.uid);
        userModel?.setToken(token);
      }
      locator.get<UserController>().initUser(userModel);
      return userModel;
    }
  }
}
