import 'package:ridesharingapp/services/Authentication/models/app_user.dart';

abstract class AuthProvider {
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<void> initialize();
  Future<AppUser?> get currentUser;
  Future<void> logout();
}
