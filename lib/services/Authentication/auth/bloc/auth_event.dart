abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  AuthEventRegister(this.email, this.password);
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

class AuthEventSelectRole extends AuthEvent {
  const AuthEventSelectRole();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
