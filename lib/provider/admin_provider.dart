import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProvider{

  final _collection = "user";
  final _store = FirebaseFirestore.instance;

  Future<QuerySnapshot> findCompanyInfo() =>
      _store.collection(_collection).get();

  Future<QuerySnapshot> findByPassword(String password) =>
      _store.collection(_collection).where("password",isEqualTo: password).get();
}