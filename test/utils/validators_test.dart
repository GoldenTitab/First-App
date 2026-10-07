import 'package:first_app/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators.email', () {
    test('accepts normal addresses, plus-tags and long TLDs', () {
      expect(AppValidators.email('user@example.com'), isNull);
      expect(AppValidators.email('first.last+tag@mail.example.org'), isNull);
      expect(AppValidators.email('user@site.technology'), isNull);
      expect(AppValidators.email('  user@example.com  '), isNull);
    });

    test('rejects empty and malformed addresses', () {
      expect(AppValidators.email(null), AppStrings.requiredField);
      expect(AppValidators.email('   '), AppStrings.requiredField);
      expect(AppValidators.email('user'), AppStrings.invalidEmail);
      expect(AppValidators.email('user@'), AppStrings.invalidEmail);
      expect(AppValidators.email('user@example'), AppStrings.invalidEmail);
      expect(AppValidators.email('@example.com'), AppStrings.invalidEmail);
    });
  });

  group('AppValidators.password', () {
    test('requires at least 6 characters', () {
      expect(AppValidators.password(null), AppStrings.requiredField);
      expect(AppValidators.password(''), AppStrings.requiredField);
      expect(AppValidators.password('12345'), AppStrings.weakPassword);
      expect(AppValidators.password('123456'), isNull);
    });
  });

  group('AppValidators.required', () {
    test('rejects blank values', () {
      expect(AppValidators.required(null), AppStrings.requiredField);
      expect(AppValidators.required('  '), AppStrings.requiredField);
      expect(AppValidators.required('x'), isNull);
    });
  });
}
