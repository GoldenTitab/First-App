import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._internal() : _auth = FirebaseAuth.instance;
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  /// Creates a non-singleton instance around a custom [FirebaseAuth]
  /// (use a mock in unit tests).
  @visibleForTesting
  AuthService.withAuth(FirebaseAuth auth) : _auth = auth;

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    // Only the e-mail is trimmed: a password must be sent exactly as typed.
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
