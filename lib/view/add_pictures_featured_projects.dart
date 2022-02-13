import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:image_picker/image_picker.dart';

import 'home_customer_screen.dart';

class AddPicturesFeaturedProjects extends StatefulWidget {
  static const String routeName = '/add_pictures_featured_projects';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => AddPicturesFeaturedProjects(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<AddPicturesFeaturedProjects> createState() =>
      _AddPicturesFeaturedProjectsState();
}

class _AddPicturesFeaturedProjectsState
    extends State<AddPicturesFeaturedProjects> {
  bool uploading = false;
  double val = 0;

  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  locator
                      .get<UserController>()
                      .uploadFiles(_image)
                      .whenComplete(() => Navigator.pushNamed(
                          context, HomeCustomerScreen.routeName));
                  setState(() {});
                },
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    var image = (await ImagePicker().getImage(source: ImageSource.gallery));
    if (image != null) {
      setState(() {
        _image.add(File(image.path));
      });
    }
  }
}
