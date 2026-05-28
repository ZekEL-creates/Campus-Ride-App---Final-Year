import 'package:ridesharingapp/services/Authentication/auth/auth_provider.dart';
import 'package:ridesharingapp/services/Authentication/auth/firebase_auth_provider.dart';
import 'package:ridesharingapp/services/Authentication/models/app_user.dart';

class AuthService extends AuthProvider {
  final AuthProvider provider;
  AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async => await provider.login(email: email, password: password);

  @override
  Future<void> logout() async {
    provider.logout();
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async => await provider.signUp(
    email: email,
    password: password,
    name: name,
    role: role,
  );

  @override
  Future<AppUser?> get currentUser => provider.currentUser;
}
