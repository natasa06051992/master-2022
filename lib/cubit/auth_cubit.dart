import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_master/cubit/firebase_firestore_repo.dart';
import 'package:flutter_master/cubit/storage_repo.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthDefault());

  // initalizing the instance for our facebook
  // google and firebase
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookSignIn = FacebookAuth.instance;

  // login method
  Future login(String email, String password) async {
    emit(const AuthLoginLoading());
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      // login success state
      if (user != null) {
        await createCurrentUser(user);

        emit(AuthLoginSuccess(user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginError(error: e.message!));
    }
  }

  Future<void> createCurrentUser(User user) async {
    String selectedRole =
        await locator.get<FirebaseFirestoreRepo>().getRole(user);
    String? selectedService;
    if (selectedRole.contains('Handyman')) {
      selectedService =
          await locator.get<FirebaseFirestoreRepo>().getService(user);
    }
    await locator
        .get<FirebaseFirestoreRepo>()
        .getLocation(user)
        .then((value) => createUser(value, selectedRole, selectedService));
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
      bool isAlreadyCreatedAcount) async {
    emit(const AuthSignUpLoading());
    try {
      User? user;

      if (!isAlreadyCreatedAcount) {
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
            .then((value) =>
                createUser(selectedLocation, selectedRole, selectedService))
            .then((value) =>
                locator.get<FirebaseFirestoreRepo>().addUserToFirebase(value))
            .then((value) => emit(const AuthSignUpSuccess()));
      }
    } on FirebaseAuthException catch (e) {
      firebaseAuth.currentUser?.delete();
      emit(AuthSignUpError(e.message));
    }
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

  Future googleAuth() async {
    emit(const AuthGoogleLoading());
    try {
      final GoogleSignInAccount? _googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await _googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      bool isSigndUpUser = await locator
          .get<FirebaseFirestoreRepo>()
          .checkIfUserIsSignedUp(user!.uid);
      if (user != null && isSigndUpUser) {
        await createCurrentUser(user);
        emit(AuthGoogleSuccess(user: user));
      } else {
        emit(AuthGoogleError(error: "User is not signed up!"));
      }
    } catch (e) {
      emit(AuthGoogleError(error: e.toString()));
    }
  }

  Future facebookAuth() async {
    try {
      emit(AuthFBLoading());
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
          if (userCredential != null && isSigndUpUser) {
            await createCurrentUser(userCredential);
            emit(AuthFBSuccess(user: userCredential));
          }
          return;

        case LoginStatus.failed:
          return emit(AuthFBError());
        default:
          return emit(AuthFBError());
      }
    } on FirebaseAuthException catch (e) {
      emit(const AuthFBError());
      //throw e;
    }
  }

  Future googleLogout() async {
    userModel = null;
    await googleSignIn.signOut();
    emit(const AuthLogout());
  }

  Future fbLogout() async {
    userModel = null;
    await facebookSignIn.logOut();
    emit(const AuthLogout());
  }

  // auth logou
  Future logout() async {
    userModel = null;
    await firebaseAuth.signOut();
    emit(const AuthLogout());
  }

  static UserModel? userModel;
  String? role;
  getUser() {
    if (firebaseAuth.currentUser != null && userModel != null) {
      return userModel;
    }
  }

  void updateDisplayName(String text) async {
    firebaseAuth.currentUser!.updateDisplayName(text);
  }

  createUser(String selectedLocation, String selectedRole,
      String? selectedService) async {
    var firebaseUser = firebaseAuth.currentUser!;
    if (userModel == null && firebaseAuth.currentUser != null) {
      String? url = await getDownloadUrl(firebaseUser.uid);
      if (selectedRole.contains('Handyman')) {
        userModel = HandymanModel(
            firebaseUser.uid,
            firebaseUser.displayName!,
            firebaseUser.email!,
            firebaseUser.phoneNumber,
            selectedService,
            selectedLocation,
            url);
      } else {
        userModel = CustomerModel(
            firebaseUser.uid,
            firebaseUser.displayName!,
            firebaseUser.email!,
            firebaseUser.phoneNumber,
            selectedLocation,
            url);
      }
    }
    locator.get<UserController>().initUser(userModel);
    return userModel;
  }
}
