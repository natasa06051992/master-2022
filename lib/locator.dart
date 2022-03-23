import 'package:flutter_master/services/auth_cubit.dart';
import 'package:flutter_master/services/push_notification_service.dart';
import 'package:flutter_master/services/storage_repo.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:get_it/get_it.dart';

import 'services/firebase_firestore_repo.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthCubit>(AuthCubit());
  locator.registerSingleton<StorageRepo>(StorageRepo());

  locator.registerSingleton<FirebaseFirestoreRepo>(FirebaseFirestoreRepo());
  locator.registerSingleton<UserController>(UserController());
  locator.registerSingleton<NotificationService>(NotificationService());
}
