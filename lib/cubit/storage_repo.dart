import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';

class StorageRepo {
  AuthCubit _authRepo = locator.get<AuthCubit>();

  Future<String> uploadProfileImage(File imageFile, UserModel user) async {
    Future<String> downloadUrl = Future<String>.value("");
    var storageReference =
        FirebaseStorage.instance.ref().child("user/profile/${user.uid}");
    var uploadTask = storageReference.putFile(imageFile);
    await uploadTask
        .whenComplete(() => downloadUrl = storageReference.getDownloadURL());

    return downloadUrl;
  }

  Future<String?> getUserProfileImageUrl(String uid) async {
    // return await FirebaseStorage.instance
    //     .ref()
    //     .child("user/profile/$uid")
    //     .getDownloadURL();

    var ref = FirebaseStorage.instance.ref().child("user/profile/$uid");
    try {
      return await ref.getDownloadURL();
      // Do whatever
    } catch (err) {
      return null;
      // Doesn't exist... or potentially some other error
    }
  }

  Future<List<String>?> uploadImagesFeaturedProjects(
      List<File> images, UserModel userModel) async {
    List<String> listOfUrls = [];
    for (var img in images) {
      var ref = FirebaseStorage.instance.ref().child(
          "user/featuredProjects/${userModel.uid}/${Path.basename(img.path)}");
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          listOfUrls.add(value);
        });
      });
    }
    return listOfUrls;
  }
}
