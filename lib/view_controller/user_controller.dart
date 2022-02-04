import 'dart:io';

import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/cubit/firebase_firestore_repo.dart';
import 'package:flutter_master/cubit/storage_repo.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';

class UserController {
  UserModel? _currentUser;

  final AuthCubit _authRepo = locator.get<AuthCubit>();
  final StorageRepo _storageRepo = locator.get<StorageRepo>();
  final FirebaseFirestoreRepo _firebaseFirestoreRepo =
      locator.get<FirebaseFirestoreRepo>();

  void initUser(UserModel? userModel) {
    _currentUser = userModel;
  }

  UserModel? get currentUser => _currentUser;

  uploadProfilePicture(File image) async {
    if (image != null) {
      await _storageRepo.uploadProfileImage(image, _currentUser!).then((value) {
        _currentUser!.avatarUrl = value;
        _firebaseFirestoreRepo.updateAvatarUrl(_currentUser!);
      });
    }
  }

  void updateDisplayName(String text) {
    _currentUser!.displayName = text;
    _authRepo.updateDisplayName(text);
  }

  void updateService(String text) {
    if (_currentUser is HandymanModel) {
      (_currentUser as HandymanModel)!.service = text;
      _firebaseFirestoreRepo.updateService(_currentUser!, text);
    }
  }

  void updateLocation(String text) {
    _currentUser!.location = text;
    _firebaseFirestoreRepo.updateLocation(_currentUser!, text);
  }

  void updatePhoneNumber(String text) {
    _currentUser!.phoneNumber = text;
    _firebaseFirestoreRepo.updatePhoneNumber(_currentUser!, text);
  }
}
