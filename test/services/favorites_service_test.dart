import 'package:first_app/services/favorites_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggle adds and removes a favorite', () async {
    final service = FavoritesService.forTest();
    await service.load('user-1');

    expect(await service.toggle(5), isTrue);
    expect(service.isFavorite(5), isTrue);

    expect(await service.toggle(5), isFalse);
    expect(service.isFavorite(5), isFalse);
  });

  test('favorites survive a restart (reload from disk)', () async {
    final first = FavoritesService.forTest();
    await first.load('user-1');
    await first.toggle(1);
    await first.toggle(2);

    final second = FavoritesService.forTest();
    await second.load('user-1');

    expect(second.ids, {1, 2});
  });

  test('each account has its own list', () async {
    final service = FavoritesService.forTest();
    await service.load('alice');
    await service.toggle(1);

    await service.load('bob');
    expect(service.ids, isEmpty);

    await service.load('alice');
    expect(service.ids, {1});
  });

  test('clear() empties memory and blocks toggling until the next load', () async {
    final service = FavoritesService.forTest();
    await service.load('user-1');
    await service.toggle(9);

    service.clear();
    expect(service.ids, isEmpty);
    expect(await service.toggle(9), isFalse); // nobody signed in
    expect(service.ids, isEmpty);
  });

  test('notifies listeners on change', () async {
    final service = FavoritesService.forTest();
    await service.load('user-1');

    var notifications = 0;
    service.addListener(() => notifications++);
    await service.toggle(3);

    expect(notifications, greaterThanOrEqualTo(1));
  });
}
