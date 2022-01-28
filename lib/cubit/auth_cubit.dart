import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_master/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthDefault());

  // initalizing the instance for our facebook
  // google and firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
        emit(AuthLoginSuccess(user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginError(error: e.message!));
    }
  }

  // signup method
  Future signUp(String name, String password, String email) async {
    emit(const AuthSignUpLoading());
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      // if the user is not null
      if (user != null) {
        user.updateDisplayName(name);
        emit(const AuthSignUpSuccess());
      }
    } on FirebaseAuthException catch (e) {
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
      // if (_googleUser != null) {
      //   emit(AuthDefault());
      // } else {
      final GoogleSignInAuthentication googleAuth =
          await _googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        emit(AuthGoogleSuccess(user: user));
      }
      // }
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
          if (userCredential != null) {
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
    await googleSignIn.signOut();
    emit(const AuthLogout());
  }

  Future fbLogout() async {
    await facebookSignIn.logOut();
    emit(const AuthLogout());
  }

  // auth logou
  Future logout() async {
    await firebaseAuth.signOut();
    emit(const AuthLogout());
  }

  Future<UserModel> getUser() async {
    var firebaseUser = firebaseAuth.currentUser!;
    return UserModel.create(firebaseUser.uid, firebaseUser.displayName!,
        firebaseUser.email!, firebaseUser.phoneNumber);
  }
}
