import 'package:flutter_master/cubit/auth_cubit.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/user.dart';

class UserController {
  late UserModel _currentUser;

  final AuthCubit _authRepo = locator.get<AuthCubit>();
  late Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;
  set location(String loc) {
    _currentUser.setLocation(loc);
  }
}
