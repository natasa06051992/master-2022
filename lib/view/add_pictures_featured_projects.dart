import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:image_picker/image_picker.dart';

import 'screens.dart';

class AddPicturesFeaturedProjects extends StatefulWidget {
  static const String routeName = '/add_pictures_featured_projects';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) {
          if (locator.get<UserController>().checkForInternetConnection(_)) {
            return AddPicturesFeaturedProjects();
          } else {
            return const NoInternetScreen();
          }
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<AddPicturesFeaturedProjects> createState() =>
      _AddPicturesFeaturedProjectsState();
}

class _AddPicturesFeaturedProjectsState
    extends State<AddPicturesFeaturedProjects> {
  bool uploading = false;
  double val = 0;

  final List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dodaj sliku'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  locator
                      .get<UserController>()
                      .uploadFiles(_image)
                      .whenComplete(() {
                    Navigator.pop(context);
                    //   Navigator.pushNamedAndRemoveUntil(
                    //       context,
                    //       CustomersProjects.routeName,
                    //       (Route<dynamic> route) => false);
                    //
                  });
                  setState(() {});
                },
                child: const Text(
                  'Sačuvati',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: const EdgeInsets.all(3),
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
                      const Text(
                        'čuvanje...',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
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
