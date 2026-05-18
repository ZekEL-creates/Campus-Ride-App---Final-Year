import 'package:ridesharingapp/services/Authentication/auth/auth_user.dart';

abstract class AuthProvider {
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> signUp({required String email, required String password});
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<void> logout();
}
