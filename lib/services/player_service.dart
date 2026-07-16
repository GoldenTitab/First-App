import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../utils/constants.dart';

class PlayerService extends ChangeNotifier {
  PlayerService._internal();
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _error;

  bool _initialized = false;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  String? get error => _error;

  void init() {
    if (_initialized) return;
    _initialized = true;

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      notifyListeners();
    });
  }

  Future<void> playOrPause(Song song) async {
    _error = null;
    try {
      if (_currentSong != song) {
        await _audioPlayer.play(UrlSource(song.audioUrl));
        _currentSong = song;
        _isPlaying = true;
        _currentPosition = Duration.zero;
      } else {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.resume();
        }
      }
      notifyListeners();
    } catch (e) {
      _error = '${AppStrings.playError} ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _isPlaying = false;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
