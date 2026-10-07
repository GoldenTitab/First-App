import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/song_service.dart';
import '../widgets/custom_dialog.dart';
import 'constants.dart';

class ExceptionHandler {
  ExceptionHandler._();

  static Future<void> showErrorDialog(
    BuildContext context,
    Object error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) async {
    final String message = customMessage?.isNotEmpty == true
        ? customMessage!
        : messageFor(error);
    await CustomDialog.showError(context, message, onRetry: onRetry);
  }

  /// Converts any error into a short, user-friendly Persian message.
  /// Raw exception text is never shown to the user.
  static String messageFor(Object error) {
    // Order matters: the most specific types first.
    if (error is FirebaseAuthException) {
      return _firebaseAuthMessage(error);
    }
    if (error is SongServiceException) {
      return error.message;
    }
    if (error is TimeoutException) {
      return AppStrings.timeoutError;
    }
    if (error is FormatException) {
      return AppStrings.invalidFormat;
    }

    final String raw = error.toString();
    if (raw.contains('SocketException') ||
        raw.contains('ClientException') ||
        raw.contains('Failed host lookup')) {
      return AppStrings.networkError;
    }
    if (raw.contains('403') || raw.contains('Forbidden')) {
      return AppStrings.networkError;
    }
    // Never leak HTML error pages or stack traces into the UI.
    return AppStrings.genericError;
  }

  static String _firebaseAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      // Firebase now reports a single `invalid-credential` for both an unknown
      // e-mail and a wrong password (email-enumeration protection), but the
      // legacy codes are still handled for older projects.
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return AppStrings.wrongCredentials;
      case 'user-not-found':
        return AppStrings.userNotFound;
      case 'wrong-password':
        return AppStrings.wrongPassword;
      case 'invalid-email':
        return AppStrings.invalidEmail;
      case 'weak-password':
        return AppStrings.weakPassword;
      case 'email-already-in-use':
        return AppStrings.emailAlreadyExists;
      case 'user-disabled':
        return AppStrings.userDisabled;
      case 'network-request-failed':
        return AppStrings.networkError;
      case 'too-many-requests':
        return AppStrings.tooManyRequests;
      default:
        return AppStrings.genericError;
    }
  }
}
