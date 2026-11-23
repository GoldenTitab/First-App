import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/song.dart';
import '../utils/constants.dart';

class SongService {
  SongService._internal() : _client = http.Client(), _now = DateTime.now;
  static final SongService _instance = SongService._internal();
  factory SongService() => _instance;

  @visibleForTesting
  SongService.withClient(http.Client client, {DateTime Function()? now})
    : _client = client,
      _now = now ?? DateTime.now;

  final http.Client _client;
  final DateTime Function() _now;

  static const String _baseUrl = 'https://goldentitab.github.io/songs.json';
  static const Duration _cacheExpiry = Duration(minutes: 10);
  static const Duration _requestTimeout = Duration(seconds: 15);

  List<Song>? _cachedSongs;
  DateTime? _cacheTime;

  bool get _isCacheValid =>
      _cachedSongs != null &&
      _cacheTime != null &&
      _now().difference(_cacheTime!) < _cacheExpiry;

  Future<List<Song>> fetchSongs({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) {
      return _cachedSongs!;
    }

    try {
      final response = await _client
          .get(Uri.parse(_baseUrl))
          .timeout(_requestTimeout);

      if (response.statusCode != 200) {
        throw SongServiceException(
          '${AppStrings.fetchSongsErrorWithCode} ${response.statusCode})',
        );
      }

      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded is! List) {
        throw const FormatException('Expected a JSON array of songs.');
      }

      final songs = <Song>[];
      for (final item in decoded) {
        try {
          final song = Song.fromJson(item as Map<String, dynamic>);
          if (song.audioUrl.isEmpty) continue;
          songs.add(song);
        } catch (e) {
          debugPrint('Skipping invalid song entry: $e');
        }
      }

      _cachedSongs = songs;
      _cacheTime = _now();
      return songs;
    } on SongServiceException {
      final stale = _staleFallback(forceRefresh);
      if (stale != null) return stale;
      rethrow;
    } on TimeoutException {
      return _fallbackOrThrow(forceRefresh, AppStrings.timeoutError);
    } on http.ClientException {
      return _fallbackOrThrow(forceRefresh, AppStrings.networkError);
    } on FormatException {
      return _fallbackOrThrow(forceRefresh, AppStrings.invalidFormat);
    } catch (e) {
      debugPrint('fetchSongs failed: $e');
      return _fallbackOrThrow(forceRefresh, AppStrings.fetchSongsListError);
    }
  }

  List<Song>? _staleFallback(bool forceRefresh) =>
      forceRefresh ? null : _cachedSongs;

  List<Song> _fallbackOrThrow(bool forceRefresh, String message) {
    final stale = _staleFallback(forceRefresh);
    if (stale != null) return stale;
    throw SongServiceException(message);
  }

  void clearCache() {
    _cachedSongs = null;
    _cacheTime = null;
  }
}

class SongServiceException implements Exception {
  final String message;
  const SongServiceException(this.message);

  @override
  String toString() => message;
}
