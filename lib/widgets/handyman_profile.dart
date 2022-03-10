import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/add_pictures_featured_projects.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class HandymanProfile extends StatefulWidget {
  final UserModel currentUser;
  final GlobalKey<FormBuilderState> formKey;
  const HandymanProfile(
    this.currentUser,
    this.formKey,
  );

  @override
  State<HandymanProfile> createState() => _HandymanProfileState();
}

class _HandymanProfileState extends State<HandymanProfile> {
  var _descriptionController = TextEditingController();
  var _startingCostController = TextEditingController();
  var _yearsInBusinessController = TextEditingController();

  void saveProfile() {
    var _selectedServices = (widget.currentUser as HandymanModel).service;
    if (_selectedServices != null &&
        _selectedServices != (widget.currentUser as HandymanModel).service) {
      locator.get<UserController>().updateService(_selectedServices!);
    }
    if (widget.currentUser is HandymanModel &&
        _descriptionController.text != "" &&
        _descriptionController.text !=
            (widget.currentUser as HandymanModel).description) {
      locator
          .get<UserController>()
          .updateDescription(_descriptionController.text);
    }
    if (widget.currentUser is HandymanModel &&
        _startingCostController.text != "contact for price" &&
        widget.formKey.currentState!.validate() &&
        _startingCostController.text !=
            (widget.currentUser as HandymanModel).startingPrice.toString()) {
      locator
          .get<UserController>()
          .updateStartingCost(_startingCostController.text as int);
    }
    if (widget.currentUser is HandymanModel &&
        _yearsInBusinessController.text != "" &&
        widget.formKey.currentState!.validate() &&
        _yearsInBusinessController.text !=
            (widget.currentUser as HandymanModel).yearsInBusiness.toString()) {
      locator
          .get<UserController>()
          .updateYearsInBusiness(_yearsInBusinessController.text as int);
    }
  }

  @override
  void initState() {
    _descriptionController.text =
        (widget.currentUser as HandymanModel).description ?? "";
    _startingCostController.text =
        (widget.currentUser as HandymanModel).startingPrice?.toString() ??
            "Contact for starting price";
    _yearsInBusinessController.text =
        (widget.currentUser as HandymanModel).yearsInBusiness?.toString() ?? "";

    super.initState();
  }

  // @override
  // void dispose() {
  //   _descriptionController.dispose();
  //   _startingCostController.dispose();
  //   _yearsInBusinessController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = [];
    var _selectedServices = (widget.currentUser as HandymanModel).service;
    imageSliders = createWidget();

    return FormBuilder(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "Description"),
              controller: _descriptionController,
            ),
            TextFormField(
                decoration: InputDecoration(hintText: "Starting cost"),
                controller: _startingCostController,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.integer(context,
                      errorText: "Enter a number (whole-valued)")
                ])),
            TextFormField(
                decoration: InputDecoration(hintText: "Years in Business"),
                controller: _yearsInBusinessController,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.integer(context,
                      errorText: "Enter a number (whole-valued)")
                ])),
            DropdownButton(
              hint: const Text(
                  'Please choose a service'), // Not necessary for Option 1
              value: _selectedServices,
              onChanged: (newValue) {
                setState(() {
                  _selectedServices = newValue.toString();
                });
              },
              items: Constants.services.map((_selectedService) {
                return DropdownMenuItem(
                  child: Text(_selectedService),
                  value: _selectedService,
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            if (imageSliders.length > 0)
              Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 2,
                  autoPlay: true,
                ),
                items: imageSliders,
              )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AddPicturesFeaturedProjects.routeName);
                },
                child: Text("Add pictures of featured projects")),
          ],
        ),
      ),
    );
  }

  List<Widget> createWidget() {
    if ((widget.currentUser as HandymanModel).urlToGallery != null &&
        (widget.currentUser as HandymanModel).urlToGallery!.length > 0) {
      return (widget.currentUser as HandymanModel)
          .urlToGallery!
          .map((item) => Container(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(item, fit: BoxFit.cover, width: 1000.0),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ),
                          ),
                        ],
                      )),
                ),
              ))
          .toList();
    }
    return [];
  }
}
