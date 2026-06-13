import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:ridesharingapp/firebase_options.dart';
import 'package:ridesharingapp/features/Authentication/data/auth_exceptions/auth_exceptions.dart';
import 'package:ridesharingapp/features/Authentication/auth_service/auth_provider.dart';
import 'package:ridesharingapp/features/Authentication/data/models/app_user.dart';
import 'package:ridesharingapp/services/firebase_storage_service.dart';

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
    final userStorage = FirebaseStorageService();
    final String collectionName = 'users';
    //final users = FirebaseFirestore.instance.collection('users');
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        final user = await userStorage.getData(
          collectionName: collectionName,
          id: firebaseUser.uid,
          fromJson: AppUser.fromJson,
        );
        if (user == null) {
          await FirebaseAuth.instance.signOut();
          throw UserNotLoggedInAuthException();
        }
        return user;

        // final doc = await users.doc(firebaseUser.uid).get();
        // if (!doc.exists) {
        //   await FirebaseAuth.instance.signOut();
        //   throw UserNotLoggedInAuthException();
        // }
        // final user = AppUser.fromJson(doc.data()!);
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
    final userStorage = FirebaseStorageService();
    final String collectionName = 'users';
    final String driverCollectionName = 'drivers';
    // final users = FirebaseFirestore.instance.collection('users');
    // final drivers = FirebaseFirestore.instance.collection('drivers');
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
        await userStorage.create(
          collectionName: collectionName,
          id: firebaseUser.uid,
          data: user.toJson(),
        );
        if (user.role == 'driver') {
          await userStorage.create(
            collectionName: driverCollectionName,
            id: firebaseUser.uid,
            data: user.toJson(),
          );
        }
        // await users.doc(firebaseUser.uid).set(user.toJson());
        // if (user.role == 'driver') {
        //   await drivers.doc(firebaseUser.uid).set(user.toJson());
        // }
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
    final userStorage = FirebaseStorageService();
    final String collectionName = 'users';
    //final users = FirebaseFirestore.instance.collection('users');
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return userStorage.getData(
        collectionName: collectionName,
        id: user.uid,
        fromJson: AppUser.fromJson,
      );

      // final doc = await users.doc(user.uid).get();
      // final currentUser = doc.data();
      // return AppUser.fromJson(currentUser!);
    } else {
      return null;
    }
  }
}
