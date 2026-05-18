abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  AuthEventLogIn(this.email, this.password);
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
