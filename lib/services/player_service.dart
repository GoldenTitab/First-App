import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/song.dart';
import '../utils/constants.dart';

class PlayerService extends ChangeNotifier {
  PlayerService._internal();
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final ValueNotifier<Duration> positionNotifier = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> durationNotifier = ValueNotifier(Duration.zero);

  final List<StreamSubscription<Object?>> _subscriptions = [];

  List<Song> _queue = const [];
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasSource = false;
  String? _error;
  bool _initialized = false;

  int _requestId = 0;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Duration get currentPosition => positionNotifier.value;
  Duration get totalDuration => durationNotifier.value;

  int get _currentIndex {
    final song = _currentSong;
    return song == null ? -1 : _queue.indexOf(song);
  }

  bool get hasNext {
    final i = _currentIndex;
    return i >= 0 && i < _queue.length - 1;
  }

  bool get hasPrevious => _currentIndex > 0;

  void init() {
    if (_initialized) return;
    _initialized = true;

    _subscriptions.addAll([
      _audioPlayer.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        notifyListeners();
      }),
      _audioPlayer.onPositionChanged.listen((position) {
        positionNotifier.value = position;
      }),
      _audioPlayer.onDurationChanged.listen((duration) {
        durationNotifier.value = duration;
      }),
      _audioPlayer.onPlayerComplete.listen((_) => _onTrackComplete()),
    ]);
  }

  void _onTrackComplete() {
    _hasSource = false;
    _isPlaying = false;
    positionNotifier.value = Duration.zero;
    if (hasNext) {
      unawaited(next());
    } else {
      notifyListeners();
    }
  }

  Future<void> playOrPause(Song song, {List<Song>? queue}) async {
    if (queue != null) _queue = List.unmodifiable(queue);

    if (_currentSong == song && _hasSource) {
      await togglePlayPause();
    } else {
      await _start(song);
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentSong == null) return;
    if (!_hasSource) {
      await _start(_currentSong!);
      return;
    }
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> next() async {
    final i = _currentIndex;
    if (i < 0 || i >= _queue.length - 1) return;
    await _start(_queue[i + 1]);
  }

  Future<void> previous() async {
    final i = _currentIndex;
    final restart =
        positionNotifier.value > const Duration(seconds: 3) || i <= 0;
    if (restart) {
      await seek(Duration.zero);
    } else {
      await _start(_queue[i - 1]);
    }
  }

  Future<void> seek(Duration position) async {
    if (_currentSong == null || !_hasSource) return;
    final total = durationNotifier.value;
    var target = position < Duration.zero ? Duration.zero : position;
    if (total > Duration.zero && target > total) target = total;
    try {
      await _audioPlayer.seek(target);
      positionNotifier.value = target;
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> stop() async {
    _requestId++;
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Player stop failed: $e');
    }
    _currentSong = null;
    _isPlaying = false;
    _isLoading = false;
    _hasSource = false;
    positionNotifier.value = Duration.zero;
    durationNotifier.value = Duration.zero;
    notifyListeners();
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  Future<void> _start(Song song) async {
    final request = ++_requestId;

    _error = null;
    _currentSong = song;
    _isLoading = true;
    _isPlaying = false;
    _hasSource = false;
    positionNotifier.value = Duration.zero;
    durationNotifier.value =
        song.duration > 0 ? Duration(seconds: song.duration) : Duration.zero;
    notifyListeners();

    try {
      await _audioPlayer.play(UrlSource(song.audioUrl));
      if (request != _requestId) return;
      _hasSource = true;
    } catch (e) {
      if (request != _requestId) return;
      _fail(e);
      return;
    }
    _isLoading = false;
    notifyListeners();
  }

  void _fail(Object e) {
    debugPrint('Playback error: $e');
    _error = AppStrings.playbackError;
    _isLoading = false;
    _isPlaying = false;
    _hasSource = false;
    notifyListeners();
  }

  @override
  void dispose() {}
}
