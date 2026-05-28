abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  AuthEventLogIn(this.email, this.password);
}

class AuthEventRiderRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String role;
  AuthEventRiderRegister({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}

class AuthEventDriverRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String role;
  AuthEventDriverRegister({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}

class AuthEventRegistrationSuccess extends AuthEvent {
  const AuthEventRegistrationSuccess();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSelectRiderRole extends AuthEvent {
  const AuthEventSelectRiderRole();
}

class AuthEventSelectDriverRole extends AuthEvent {
  const AuthEventSelectDriverRole();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
