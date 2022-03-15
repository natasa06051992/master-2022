import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_master/model/user.dart';

class StorageRepo {
  String featuredProjects = "user/featuredProjects/";
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
    var ref = FirebaseStorage.instance.ref().child("user/profile/$uid");
    try {
      return await ref.getDownloadURL();
    } catch (err) {
      return null;
    }
  }

  Future<List<String>?> uploadImagesFeaturedProjects(
      List<File> images, UserModel userModel) async {
    List<String> listOfUrls = [];
    for (var img in images) {
      var ref = FirebaseStorage.instance.ref().child(
          "${featuredProjects}${userModel.uid}/${path.basename(img.path)}");
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          listOfUrls.add(value);
        });
      });
    }
    return listOfUrls;
  }
}
