import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song.dart';

class SongService {
  static const String baseUrl = 'https://goldentitab.github.io/songs.json';

  Future<List<Song>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Song.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load songs (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}
