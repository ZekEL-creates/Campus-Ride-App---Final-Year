import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:ridesharingapp/firebase_options.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_exceptions.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridesharingapp/services/Authentication/models/app_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final users = FirebaseFirestore.instance.collection('users');
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        final doc = await users.doc(firebaseUser.uid).get();
        if (!doc.exists) {
          await FirebaseAuth.instance.signOut();
          throw UserNotLoggedInAuthException();
        }
        final user = AppUser.fromJson(doc.data()!);
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw InvalidCredentialAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final users = FirebaseFirestore.instance.collection('users');
    final drivers = FirebaseFirestore.instance.collection('drivers');
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        final user = AppUser(
          id: firebaseUser.uid,
          name: name,
          email: email,
          role: role,
        );
        await users.doc(firebaseUser.uid).set(user.toJson());
        if (user.role == 'driver') {
          await drivers.doc(firebaseUser.uid).set(user.toJson());
        }
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AppUser?> get currentUser async {
    final users = FirebaseFirestore.instance.collection('users');
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await users.doc(user.uid).get();
      final currentUser = doc.data();
      return AppUser.fromJson(currentUser!);
    } else {
      return null;
    }
  }
}
