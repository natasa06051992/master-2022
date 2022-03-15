import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:photo_view/photo_view.dart';

import 'package:flutter_master/config/constants.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/add_pictures_featured_projects.dart';
import 'package:flutter_master/view/customers_projects_screen.dart';
import 'package:flutter_master/view/screens.dart';
import 'package:flutter_master/view_controller/user_controller.dart';

class InformationsAboutUserWidget extends StatefulWidget {
  final UserModel currentUser;
  const InformationsAboutUserWidget(
    this.currentUser,
  );

  @override
  State<InformationsAboutUserWidget> createState() =>
      _InformationsAboutUserWidgetState();
}

String _selectedLocation = locator.get<UserController>().currentUser!.location;

class _InformationsAboutUserWidgetState
    extends State<InformationsAboutUserWidget> {
  final _displayNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startingCostController = TextEditingController();
  final _yearsInBusinessController = TextEditingController();
  String? _selectedServices;
  @override
  void initState() {
    _displayNameController.text = widget.currentUser.displayName!;
    _phoneNumberController.text = widget.currentUser.phoneNumber ?? "";
    _selectedServices = locator.get<UserController>().currentUser!
            is HandymanModel
        ? (locator.get<UserController>().currentUser! as HandymanModel).service
        : '';
    if (widget.currentUser is HandymanModel) {
      _descriptionController.text =
          (widget.currentUser as HandymanModel).description ?? "";
      _startingCostController.text =
          (widget.currentUser as HandymanModel).startingPrice?.toString() ?? "";
      _yearsInBusinessController.text =
          (widget.currentUser as HandymanModel).yearsInBusiness?.toString() ??
              "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    _descriptionController.dispose();
    _startingCostController.dispose();
    _yearsInBusinessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = [];
    if (widget.currentUser is HandymanModel &&
        (widget.currentUser as HandymanModel).urlToGallery != null) {
      imageSliders = (widget.currentUser as HandymanModel)
          .urlToGallery!
          .map((item) => Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        PhotoView(imageProvider: NetworkImage(item)),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ))
          .toList();
    }

    final formKey = GlobalKey<FormBuilderState>();

    return FormBuilder(
      autovalidateMode: AutovalidateMode.disabled,
      key: formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Ime",
                labelText: 'Ime :',
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            controller: _displayNameController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Broj telefona",
                labelText: 'Broj telefona :',
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            controller: _phoneNumberController,
          ),
          if (widget.currentUser is HandymanModel)
            TextFormField(
                decoration: const InputDecoration(
                    hintText: "Početna cena (RSD)",
                    labelText: 'Početna cena (RSD):',
                    labelStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                controller: _startingCostController,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.integer(context,
                      errorText: "Enter a number (whole-valued)")
                ])),
          if (widget.currentUser is HandymanModel)
            TextFormField(
                decoration: const InputDecoration(
                    hintText: "Godine iskustva",
                    labelText: 'Godine iskustva :',
                    labelStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                controller: _yearsInBusinessController,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.integer(context,
                      errorText: "Enter a number (whole-valued)")
                ])),
          DropdownButtonFormField(
            decoration: const InputDecoration(
                labelText: 'Lokacija :',
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            hint: const Text(
                'Please choose a location'), // Not necessary for Option 1
            value: _selectedLocation,
            onChanged: (newValue) {
              setState(() {
                _selectedLocation = newValue.toString();
              });
            },
            items: Constants.locations.map((location) {
              return DropdownMenuItem(
                child: Text(location),
                value: location,
              );
            }).toList(),
          ),
          if (widget.currentUser is HandymanModel)
            DropdownButtonFormField(
              decoration: const InputDecoration(
                  labelText: 'Kategorija :',
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              hint: const Text(
                  'Please choose a service'), // Not necessary for Option 1
              value: _selectedServices,
              onChanged: (newValue) {
                setState(() {
                  _selectedServices = newValue.toString();
                });
              },
              items: Constants.services.map((service) {
                return DropdownMenuItem(
                  child: Text(service),
                  value: service,
                );
              }).toList(),
            ),
          if (widget.currentUser is HandymanModel)
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                  hintText: "Opis",
                  labelText: 'Opis :',
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              controller: _descriptionController,
            ),
          const SizedBox(height: 20.0),
          if (imageSliders.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                initialPage: 2,
                autoPlay: true,
              ),
              items: imageSliders,
            ),
          if (widget.currentUser is HandymanModel)
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AddPicturesFeaturedProjects.routeName);
                },
                child: const Text("Dodati slike projekata")),
          const SizedBox(height: 20.0),
          RaisedButton(
            onPressed: () {
              saveProfile(
                  _selectedLocation, _selectedServices, formKey, context);
            },
            child: const Text("Sačuvati profil"),
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.currentUser is CustomerModel)
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(green)),
                onPressed: () =>
                    Navigator.pushNamed(context, CustomersProjects.routeName),
                child: const Text('Moji oglasi')),
          if (widget.currentUser is HandymanModel)
            RaisedButton(
              color: green,
              onPressed: () {
                Navigator.pushNamed(context, ReviewsScreen.routeName,
                    arguments: locator.get<UserController>().currentUser);
              },
              child: const Text("Moje recenzije"),
            ),
          BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
            if (state is AuthLoginError || state is AuthGoogleError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.errorMessage!),
                ));
            } else if (state is AuthLoginSuccess ||
                state is AuthGoogleSuccess ||
                state is AuthDefault) {
              Navigator.pushNamed(context, '/home');
            }
          }, builder: (context, state) {
            return Logout(state);
          })
        ]),
      ),
    );
  }

  void saveProfile(String _selectedLocation, String? _selectedServices,
      GlobalKey<FormBuilderState> formKey, BuildContext context) {
    if (_displayNameController.text != widget.currentUser.displayName) {
      locator
          .get<UserController>()
          .updateDisplayName(_displayNameController.text);
    }
    if (_phoneNumberController.text != widget.currentUser.phoneNumber) {
      locator
          .get<UserController>()
          .updatePhoneNumber(_phoneNumberController.text);
    }
    if (_selectedLocation != widget.currentUser.location) {
      locator.get<UserController>().updateLocation(_selectedLocation);
    }
    if (widget.currentUser is HandymanModel &&
        _selectedServices != null &&
        _selectedServices != (widget.currentUser as HandymanModel).service) {
      locator.get<UserController>().updateService(_selectedServices);
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
        _startingCostController.text != "" &&
        formKey.currentState!.validate() &&
        _startingCostController.text !=
            (widget.currentUser as HandymanModel).startingPrice.toString()) {
      locator
          .get<UserController>()
          .updateStartingCost(int.parse(_startingCostController.text));
    }
    if (widget.currentUser is HandymanModel &&
        _yearsInBusinessController.text != "" &&
        formKey.currentState!.validate() &&
        _yearsInBusinessController.text !=
            (widget.currentUser as HandymanModel).yearsInBusiness.toString()) {
      locator
          .get<UserController>()
          .updateYearsInBusiness(int.parse(_yearsInBusinessController.text));
    }
    Navigator.pop(context);
  }
}

class Logout extends StatelessWidget {
  final AuthState state;
  const Logout(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      TextButton.icon(
        icon: const Icon(Icons.exit_to_app),
        label: const Text('Odjavi se'),
        onPressed: () async {
          if (state is AuthDefault || state is AuthGoogleSuccess) {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.logout();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Logout was successuful"),
              ));
          } else if (state is AuthLoginSuccess || state is AuthSignUpSuccess) {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.logout();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Logout was successuful"),
              ));
          } else if (state is AuthFBSuccess) {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.logout();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("Logout was successuful"),
              ));
          }

          Navigator.pushNamedAndRemoveUntil(context, OnBoardingScreen.routeName,
              (Route<dynamic> route) => false);
        },
      )
    ]);
  }
}
