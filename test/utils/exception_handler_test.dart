import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/services/song_service.dart';
import 'package:first_app/utils/constants.dart';
import 'package:first_app/utils/exception_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExceptionHandler.messageFor', () {
    test('maps Firebase auth codes', () {
      String msg(String code) =>
          ExceptionHandler.messageFor(FirebaseAuthException(code: code));

      expect(msg('invalid-credential'), AppStrings.wrongCredentials);
      expect(msg('user-not-found'), AppStrings.userNotFound);
      expect(msg('wrong-password'), AppStrings.wrongPassword);
      expect(msg('email-already-in-use'), AppStrings.emailAlreadyExists);
      expect(msg('network-request-failed'), AppStrings.networkError);
      expect(msg('too-many-requests'), AppStrings.tooManyRequests);
      expect(msg('something-new'), AppStrings.genericError);
    });

    test('SongServiceException keeps its own message', () {
      expect(
        ExceptionHandler.messageFor(const SongServiceException('custom')),
        'custom',
      );
    });

    test('timeouts and format errors get dedicated messages', () {
      expect(ExceptionHandler.messageFor(TimeoutException('t')),
          AppStrings.timeoutError);
      expect(ExceptionHandler.messageFor(const FormatException('f')),
          AppStrings.invalidFormat);
    });

    test('unknown errors never leak raw text', () {
      expect(
        ExceptionHandler.messageFor(StateError('secret internal detail')),
        AppStrings.genericError,
      );
      expect(
        ExceptionHandler.messageFor('<!DOCTYPE html><html>'),
        AppStrings.genericError,
      );
    });
  });
}
