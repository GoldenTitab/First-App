import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song.dart';
import '../utils/constants.dart';

class SongService {
  SongService._internal();
  static final SongService _instance = SongService._internal();
  factory SongService() => _instance;

  static const String _baseUrl = 'https://goldentitab.github.io/songs.json';
  static const Duration _cacheExpiry = Duration(minutes: 10);

  List<Song>? _cachedSongs;
  DateTime? _cacheTime;

  bool get _isCacheValid =>
      _cachedSongs != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < _cacheExpiry;

  Future<List<Song>> fetchSongs({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) {
      return _cachedSongs!;
    }

    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List;
        final songs = jsonList
            .map((item) => Song.fromJson(item as Map<String, dynamic>))
            .toList();

        _cachedSongs = songs;
        _cacheTime = DateTime.now();
        return songs;
      } else {
        throw SongServiceException(
          '${AppStrings.fetchSongsErrorWithCode} ${response.statusCode})',
        );
      }
    } on SongServiceException {
      rethrow;
    } catch (e) {
      throw SongServiceException(
        '${AppStrings.fetchSongsError} ${e.toString()}',
      );
    }
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
