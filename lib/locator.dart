import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthCubit>(AuthCubit());
  locator.registerSingleton<UserController>(UserController());
}
