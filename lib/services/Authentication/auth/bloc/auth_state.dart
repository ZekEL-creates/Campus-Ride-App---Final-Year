import 'package:equatable/equatable.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_user.dart';
import 'package:ridesharingapp/services/Authentication/models/app_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateUnintialized extends AuthState {
  const AuthStateUnintialized();
}

class AuthStateLoggedInAsRider extends AuthState {
  final AppUser rider;
  const AuthStateLoggedInAsRider(this.rider);
}

class AuthStateLoggedInAsDriver extends AuthState {
  final AppUser driver;

  AuthStateLoggedInAsDriver(this.driver);
}

class AuthStateRiderRegistering extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateRiderRegistering({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateDriverRegistering extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateDriverRegistering({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateSelectRole extends AuthState {
  const AuthStateSelectRole();
}

class AuthStateRegistered extends AuthState {
  const AuthStateRegistered();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({required this.exception, required this.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}
