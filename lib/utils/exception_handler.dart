import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/services/song_service.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import '../widgets/custom_dialog.dart';

class ExceptionHandler {
  ExceptionHandler._();

  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) async {
    final String message = customMessage?.isNotEmpty == true
        ? customMessage!
        : _getUserFriendlyMessage(error);
    await CustomDialog.showError(context, message, onRetry: onRetry);
  }

  static String _getUserFriendlyMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getFirebaseAuthMessage(error);
    }
    if (error is Exception) {
      return _getGenericExceptionMessage(error);
    }
    if (error is SongServiceException) {
      return error.message;
    }
    final String raw = error.toString();
    if (raw.contains('403') || raw.contains('Forbidden')) {
      return AppStrings.networkError;
    }
    if (raw.contains('<!DOCTYPE') || raw.contains('<html')) {
      return AppStrings.genericError;
    }

    return '${AppStrings.unknownError}$raw';
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
