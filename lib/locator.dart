import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/cubit/storage_repo.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:get_it/get_it.dart';

import 'cubit/firebase_firestore_repo.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthCubit>(AuthCubit());
  locator.registerSingleton<StorageRepo>(StorageRepo());

  locator.registerSingleton<FirebaseFirestoreRepo>(FirebaseFirestoreRepo());
  locator.registerSingleton<UserController>(UserController());
}
