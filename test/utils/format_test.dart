import 'package:first_app/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats minutes and seconds', () {
    expect(formatDuration(Duration.zero), '0:00');
    expect(formatDuration(const Duration(seconds: 5)), '0:05');
    expect(formatDuration(const Duration(minutes: 3, seconds: 7)), '3:07');
  });

  test('includes hours when needed', () {
    expect(formatDuration(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03');
  });

  test('never returns a negative time', () {
    expect(formatDuration(const Duration(seconds: -4)), '0:00');
  });
}
