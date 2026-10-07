import 'package:first_app/models/song.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fullJson = <String, dynamic>{
    'id': 7,
    'title': 'Title',
    'artist': 'Artist',
    'album': 'Album',
    'genre': 'Pop',
    'duration': 185,
    'releaseYear': 2024,
    'coverUrl': 'https://example.com/cover.jpg',
    'audioUrl': 'https://example.com/song.mp3',
  };

  group('Song.fromJson', () {
    test('parses every field', () {
      final song = Song.fromJson(fullJson);
      expect(song.id, 7);
      expect(song.title, 'Title');
      expect(song.artist, 'Artist');
      expect(song.album, 'Album');
      expect(song.genre, 'Pop');
      expect(song.duration, 185);
      expect(song.releaseYear, 2024);
      expect(song.coverUrl, 'https://example.com/cover.jpg');
      expect(song.audioUrl, 'https://example.com/song.mp3');
    });

    test('uses safe defaults for missing optional fields', () {
      final song = Song.fromJson(const {'id': 1});
      expect(song.title, '');
      expect(song.duration, 0);
      expect(song.audioUrl, '');
    });

    test('accepts numeric ids/durations sent as doubles', () {
      final song = Song.fromJson(const {'id': 3.0, 'duration': 60.0});
      expect(song.id, 3);
      expect(song.duration, 60);
    });

    test('throws when the id is missing', () {
      expect(() => Song.fromJson(const {'title': 'x'}), throwsA(anything));
    });

    test('toJson round-trips', () {
      expect(Song.fromJson(fullJson).toJson(), fullJson);
    });
  });

  group('Song', () {
    test('formattedDuration pads seconds', () {
      expect(Song.fromJson({...fullJson, 'duration': 185}).formattedDuration,
          '3:05');
      expect(Song.fromJson({...fullJson, 'duration': 59}).formattedDuration,
          '0:59');
    });

    test('equality is based on the id only', () {
      final a = Song.fromJson(fullJson);
      final b = a.copyWith(title: 'Another title');
      expect(a, b);
      expect(a == a.copyWith(id: 8), isFalse);
    });
  });
}
