import 'dart:convert';

import 'package:first_app/services/song_service.dart';
import 'package:first_app/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(Object body, [int status = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json'}, // note: no charset
);

Map<String, dynamic> _song(int id, {String title = 'T'}) => {
  'id': id,
  'title': title,
  'artist': 'A',
  'album': 'B',
  'duration': 100,
  'coverUrl': 'https://example.com/c.jpg',
  'audioUrl': 'https://example.com/$id.mp3',
};

void main() {
  test('parses songs and decodes UTF-8 even without a charset header', () async {
    final service = SongService.withClient(
      MockClient((_) async => _json([_song(1, title: 'آهنگ من')])),
    );

    final songs = await service.fetchSongs();

    expect(songs, hasLength(1));
    expect(songs.first.title, 'آهنگ من');
  });

  test('skips malformed entries instead of failing the whole list', () async {
    final service = SongService.withClient(
      MockClient(
        (_) async => _json([
          _song(1),
          {'title': 'no id'},
          {..._song(3), 'audioUrl': ''}, // nothing to play
          'not even an object',
          _song(5),
        ]),
      ),
    );

    final songs = await service.fetchSongs();

    expect(songs.map((s) => s.id), [1, 5]);
  });

  test('serves the second call from the cache', () async {
    var calls = 0;
    final service = SongService.withClient(
      MockClient((_) async {
        calls++;
        return _json([_song(1)]);
      }),
    );

    await service.fetchSongs();
    await service.fetchSongs();
    expect(calls, 1);

    await service.fetchSongs(forceRefresh: true);
    expect(calls, 2);
  });

  test('throws a user-friendly error on HTTP failure', () async {
    final service = SongService.withClient(
      MockClient((_) async => _json({'error': 'x'}, 500)),
    );

    expect(
      service.fetchSongs(),
      throwsA(
        isA<SongServiceException>().having(
          (e) => e.message,
          'message',
          contains('500'),
        ),
      ),
    );
  });

  test('rejects a JSON body that is not an array', () async {
    final service = SongService.withClient(
      MockClient((_) async => _json({'songs': []})),
    );

    expect(
      service.fetchSongs(),
      throwsA(
        isA<SongServiceException>().having(
          (e) => e.message,
          'message',
          AppStrings.invalidFormat,
        ),
      ),
    );
  });

  test('re-downloads once the 10-minute cache has expired', () async {
    var now = DateTime(2026, 1, 1, 12);
    var calls = 0;
    final service = SongService.withClient(
      MockClient((_) async {
        calls++;
        return _json([_song(1)]);
      }),
      now: () => now,
    );

    await service.fetchSongs();
    now = now.add(const Duration(minutes: 9));
    await service.fetchSongs();
    expect(calls, 1); // still fresh

    now = now.add(const Duration(minutes: 2)); // 11 minutes in total
    await service.fetchSongs();
    expect(calls, 2);
  });

  test('serves stale songs when offline, unless a refresh was forced', () async {
    var now = DateTime(2026, 1, 1, 12);
    var offline = false;
    final service = SongService.withClient(
      MockClient((_) async {
        if (offline) throw http.ClientException('offline');
        return _json([_song(1)]);
      }),
      now: () => now,
    );

    await service.fetchSongs();
    now = now.add(const Duration(minutes: 11)); // cache expired
    offline = true;

    // Normal load: the old list is better than an error screen.
    final songs = await service.fetchSongs();
    expect(songs.map((s) => s.id), [1]);

    // Explicit refresh (retry button / pull-to-refresh): show the failure.
    await expectLater(
      service.fetchSongs(forceRefresh: true),
      throwsA(
        isA<SongServiceException>().having(
          (e) => e.message,
          'message',
          AppStrings.networkError,
        ),
      ),
    );
  });

  test('throws when offline and nothing was ever cached', () async {
    final service = SongService.withClient(
      MockClient((_) async => throw http.ClientException('offline')),
    );

    expect(service.fetchSongs(), throwsA(isA<SongServiceException>()));
  });
}
