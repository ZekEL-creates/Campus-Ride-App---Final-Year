import 'package:cloud_firestore/cloud_firestore.dart';
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
  }) async {
    final collection = _storage.collection(collectionName);
    await collection.doc(id).set(data);
  }

  Future<List<T>> getAllData<T>({
    required String collectionName,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final collection = _storage.collection(collectionName);
    final collectionSnapshot = await collection.get();
    final data = collectionSnapshot.docs
        .map((doc) => fromJson(doc.data()))
        .toList();
    return data;
  }

  Future<T?> getData<T>({
    required String collectionName,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final collection = _storage.collection(collectionName);
      final doc = await collection.doc(id).get();
      if (!doc.exists) {
        return null;
      }
      T data = fromJson(doc.data()!);
      return data;
    } catch (_) {
      throw CouldNotGetException();
    }
  }

  Future<void> updateNote({
    required String collectionName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final collection = _storage.collection(collectionName);
      await collection.doc(id).update(data);
    } catch (_) {
      throw CouldNotUpdateException();
    }
  }

  Future<void> deleteData({
    required String collectionName,
    required String id,
  }) async {
    final collection = _storage.collection(collectionName);
    try {
      await collection.doc(id).delete();
    } on Exception catch (_) {
      throw CouldNotDeleteException();
    }
  }
}
