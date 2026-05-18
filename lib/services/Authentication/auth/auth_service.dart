import 'package:ridesharingapp/services/Authentication/auth/auth_provider.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_user.dart';
import 'package:ridesharingapp/services/Authentication/auth/firebase_auth_provider.dart';

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
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async => await provider.login(email: email, password: password);

  @override
  Future<void> logout() async {
    provider.logout();
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async => await provider.signUp(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;
}
