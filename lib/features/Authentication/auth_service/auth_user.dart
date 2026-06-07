import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String? email;
  final String id;

  AuthUser({required this.email, required this.id});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(email: user.email, id: user.uid);
}
