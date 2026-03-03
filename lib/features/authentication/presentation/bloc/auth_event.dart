import 'package:equatable/equatable.dart';

/// Authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check authentication status on app start
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

/// Login with Google
class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}

/// Login with Facebook
class LoginWithFacebookRequested extends AuthEvent {
  const LoginWithFacebookRequested();
}

/// Login with email and password
class LoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register with email and password
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const RegisterRequested({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
