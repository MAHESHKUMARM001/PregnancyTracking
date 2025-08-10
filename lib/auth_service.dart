// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String name, bool isDoctor) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await _firestore.collection('users').doc(credential.user?.uid).set({
        'email': email,
        'name': name,
        'isDoctor': isDoctor,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isDoctor() async {
    if (_user == null) return false;
    DocumentSnapshot doc = await _firestore.collection('users').doc(_user!.uid).get();
    return doc['isDoctor'] ?? false;
  }

  Future<String> getUserName() async {
    if (_user == null) return '';
    DocumentSnapshot doc = await _firestore.collection('users').doc(_user!.uid).get();
    return doc['name'] ?? '';
  }
}