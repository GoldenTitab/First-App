import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._internal();
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;

  @visibleForTesting
  FavoritesService.forTest();

  static const String _keyPrefix = 'favorite_song_ids_';

  String? _uid;
  Set<int> _ids = <int>{};

  Set<int> get ids => Set.unmodifiable(_ids);

  bool isFavorite(int songId) => _ids.contains(songId);

  Future<void> load(String uid) async {
    _uid = uid;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('$_keyPrefix$uid') ?? const <String>[];
    _ids = stored.map(int.tryParse).whereType<int>().toSet();
    notifyListeners();
  }

  Future<bool> toggle(int songId) async {
    final uid = _uid;
    if (uid == null) return false;
    final nowFavorite = !_ids.contains(songId);
    if (nowFavorite) {
      _ids = {..._ids, songId};
    } else {
      _ids = {..._ids}..remove(songId);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      '$_keyPrefix$uid',
      _ids.map((id) => id.toString()).toList(),
    );
    return nowFavorite;
  }

  void clear() {
    _uid = null;
    _ids = <int>{};
    notifyListeners();
  }
}
