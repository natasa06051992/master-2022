part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  final User? user;
  final String? errorMessage;
  const AuthState({this.user, this.errorMessage});

  @override
  List<Object?> get props => [user, errorMessage];
}

// default state
class AuthDefault extends AuthState {}

// login state
class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess({required User user}) : super(user: user);
}

class AuthLoginError extends AuthState {
  const AuthLoginError({required String error}) : super(errorMessage: error);
}

// signup state
class AuthSignUpLoading extends AuthState {
  const AuthSignUpLoading();
}

class AuthSignUpSuccess extends AuthState {
  const AuthSignUpSuccess();
}

class AuthSignUpError extends AuthState {
  // the error message
  final String? err;
  const AuthSignUpError(this.err);

  // comparing the objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthSignUpError && other.err == err;
  }

  @override
  int get hashCode => err.hashCode;
}

// forgot password state
class AuthForgotPasswordLoading extends AuthState {
  const AuthForgotPasswordLoading();
}

class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess();
}

class AuthForgotPasswordError extends AuthState {
  final String? err;
  const AuthForgotPasswordError(this.err);
  // comparing the objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthForgotPasswordError && other.err == err;
  }

  @override
  int get hashCode => err.hashCode;
}

// google authentication state
class AuthGoogleLoading extends AuthState {
  const AuthGoogleLoading();
}

class AuthGoogleSuccess extends AuthState {
  const AuthGoogleSuccess({User? user}) : super(user: user);
}

class AuthGoogleError extends AuthState {
  const AuthGoogleError({String? error}) : super(errorMessage: error);
}

class AuthFBLoading extends AuthState {
  const AuthFBLoading();
}

class AuthFBSuccess extends AuthState {
  const AuthFBSuccess({User? user}) : super(user: user);
}

class AuthFBError extends AuthState {
  const AuthFBError({String? error}) : super(errorMessage: error);
}
// the logout

class AuthLogout extends AuthState {
  const AuthLogout();
}
