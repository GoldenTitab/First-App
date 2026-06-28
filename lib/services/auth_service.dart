// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // جریان تغییرات وضعیت احراز هویت
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // کاربر فعلی
  User? get currentUser => _auth.currentUser;

  // ورود
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // ثبت‌نام
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // ارسال ایمیل تأیید
  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  // بارگذاری مجدد کاربر (برای بررسی تأیید ایمیل)
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  // خروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // تبدیل خطاهای Firebase به پیام قابل نمایش
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AppStrings.userNotFound;
      case 'wrong-password':
        return AppStrings.wrongPassword;
      case 'invalid-email':
        return AppStrings.invalidEmail;
      case 'weak-password':
        return AppStrings.weakPassword;
      case 'email-already-in-use':
        return AppStrings.emailInUse;
      default:
        return AppStrings.genericError;
    }
  }
}
