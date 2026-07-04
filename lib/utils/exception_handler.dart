import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class ExceptionHandler {
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) async {
    String message = _getUserFriendlyMessage(error);
    if (customMessage != null && customMessage.isNotEmpty) {
      message = customMessage;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.okay),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text(AppStrings.retry),
            ),
        ],
      ),
    );
  }

  static String _getUserFriendlyMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getFirebaseAuthMessage(error);
    }
    if (error is Exception) {
      return _getGenericExceptionMessage(error);
    }
    return AppStrings.unknownError + error.toString();
  }

  static String _getFirebaseAuthMessage(FirebaseAuthException e) {
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
      case 'network-request-failed':
        return AppStrings.networkError;
      case 'too-many-requests':
        return AppStrings.tooManyRequests;
      default:
        return '${AppStrings.authenticationError}${e.message ?? e.code}';
    }
  }

  static String _getGenericExceptionMessage(Exception e) {
    if (e is FormatException) {
      return AppStrings.formatError;
    }
    if (e is TimeoutException) {
      return AppStrings.timeoutError;
    }
    return '${AppStrings.unknownError}${e.toString()}';
  }
}
