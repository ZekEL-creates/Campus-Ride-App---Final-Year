import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateUnintialized extends AuthState {
  const AuthStateUnintialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateRegistering extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateRegistering({
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
