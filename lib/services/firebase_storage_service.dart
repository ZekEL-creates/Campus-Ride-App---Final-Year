import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ridesharingapp/core/constants/constants.dart';
import 'package:ridesharingapp/services/storage_exceptions.dart';

class FirebaseStorageService {
  final _storage = FirebaseFirestore.instance;

  //singleton
  static final FirebaseStorageService _shared =
      FirebaseStorageService._sharedInstance();
  FirebaseStorageService._sharedInstance();
  factory FirebaseStorageService() => _shared;

  Future<void> create({
    required String collectionName,
    required String? id,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) async {
    print('CREAING DAA');
    try {
      await checkConnection();
      final collection = _storage.collection(collectionName);
      //added setOptions-> Incase an issue arises later
      await collection.doc(id).set(data, options);
      print('CREAED');
    } on FirebaseException catch (e) {
      print('An ERROR OCCURED ${e.code}');
      throw GenericErrorException();
    } catch (e) {
      print('An ERROR OCCURED $e');
      throw GenericErrorException();
    }
  }

  Future<List<T>> getAllData<T>({
    required String collectionName,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      await checkConnection();
      final collection = _storage.collection(collectionName);
      final collectionSnapshot = await collection.get();
      final data = collectionSnapshot.docs
          .map((doc) => fromJson(doc.data()))
          .toList();
      return data;
    } on FirebaseException catch (e) {
      print('An ERROR OCCURED ${e.code}');
      throw CouldNotGetException();
    } catch (e) {
      print('An ERROR OCCURED $e');
      throw GenericErrorException();
    }
  }

  Future<T?> getData<T>({
    required String collectionName,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      await checkConnection();
      final collection = _storage.collection(collectionName);
      final doc = await collection.doc(id).get();
      if (!doc.exists) {
        return null;
      }
      T data = fromJson(doc.data()!);
      return data;
    } on FirebaseException catch (e) {
      print('An ERROR OCCURED ${e.code}');
      throw CouldNotGetException();
    } catch (e) {
      print('An ERROR OCCURED $e');
      throw GenericErrorException();
    }
  }

  Future<void> updateData({
    required String collectionName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await checkConnection();
      final collection = _storage.collection(collectionName);
      await collection.doc(id).update(data);
    } on FirebaseException catch (e) {
      print('An ERROR OCCURED ${e.code}');
      throw CouldNotUpdateException();
    } catch (e) {
      print('An ERROR OCCURED $e');
      throw GenericErrorException();
    }
  }

  Future<void> deleteData({
    required String collectionName,
    required String id,
  }) async {
    final collection = _storage.collection(collectionName);
    try {
      await checkConnection();
      await collection.doc(id).delete();
    } on FirebaseException catch (e) {
      print('An ERROR OCCURED ${e.code}');
      throw CouldNotDeleteException();
    } catch (e) {
      print('An ERROR OCCURED $e');
      throw GenericErrorException();
    }
  }

  Stream<List<T>> getStreamData<T>({
    required String collectionName,
    required String field,
    required String isEqualTo,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    try {
      print('GEING SREAM DAA');
      final collection = _storage.collection(collectionName);
      return collection.where(field, isEqualTo: isEqualTo).snapshots().map((
        snapshot,
      ) {
        print('GO DAA');
        return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
      });
    } on FirebaseException catch (e) {
      print('An ERROR OCCURED ${e.code}');
      throw CouldNotGetException();
    } catch (e) {
      print('An ERROR OCCURED $e');
      throw GenericErrorException();
    }
  }
}
