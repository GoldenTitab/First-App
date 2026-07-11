import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/auth_service.dart';
import '../services/song_service.dart';
import '../models/song.dart';
import '../utils/constants.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/song/song_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final SongService _songService = SongService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isLoggingOut = false;
  int _currentIndex = 0;

  List<Song> _songs = [];
  bool _isLoadingSongs = true;
  String? _errorMessage;

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
    _initAudioPlayerListeners();
  }

  void _initAudioPlayerListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) setState(() => _currentPosition = position);
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _totalDuration = duration);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _fetchSongs() async {
    setState(() {
      _isLoadingSongs = true;
      _errorMessage = null;
    });
    try {
      final songs = await _songService.fetchSongs();
      setState(() {
        _songs = songs;
        _isLoadingSongs = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingSongs = false;
      });
    }
  }

  void _playOrPause(Song song) async {
    try {
      if (_currentSong != song) {
        await _audioPlayer.play(UrlSource(song.audioUrl));
        setState(() {
          _currentSong = song;
          _isPlaying = true;
          _currentPosition = Duration.zero;
        });
      } else {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در پخش: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _stopPlayback() {
    _audioPlayer.stop();
    setState(() {
      _currentSong = null;
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  Widget _buildHomeTab() {
    return SongListView(
      songs: _songs,
      isLoading: _isLoadingSongs,
      errorMessage: _errorMessage,
      onRetry: _fetchSongs,
      currentSong: _currentSong,
      isPlaying: _isPlaying,
      currentPosition: _currentPosition,
      totalDuration: _totalDuration,
      onPlayPause: _playOrPause,
    );
  }

  Widget _buildLibraryTab() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.library_music, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('کتابخانه موسیقی'),
      ],
    ),
  );

  Widget _buildFavoritesTab() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite, size: 64, color: Colors.red),
        SizedBox(height: 16),
        Text('علاقه‌مندی‌ها'),
      ],
    ),
  );

  Widget _buildProfileTab() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          _authService.currentUser?.email ?? 'کاربر',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'وضعیت: ${_authService.currentUser?.emailVerified == true ? "تأیید شده" : "تأیید نشده"}',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _stopPlayback,
          icon: const Icon(Icons.stop),
          label: const Text('توقف پخش'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    ),
  );

  Future<void> _showLogoutDialog() async {
    if (_isLoggingOut) return;
    final bool? shouldLogout = await CustomDialog.showLogoutConfirmation(
      context,
    );
    if (shouldLogout ?? false) await _performLogout();
  }

  Future<void> _performLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _audioPlayer.stop();
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.logOutError}${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final pages = [
      _buildHomeTab(),
      _buildLibraryTab(),
      _buildFavoritesTab(),
      _buildProfileTab(),
    ];

    return SafeArea(
      child: LoadingOverlay(
        isLoading: _isLoggingOut,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.homeTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _isLoggingOut ? null : _showLogoutDialog,
              ),
            ],
          ),
          body: pages[_currentIndex],
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorScheme.primary,
            onPressed: () {
              if (_currentSong != null) {
                _stopPlayback();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('پخش متوقف شد'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('هیچ آهنگی در حال پخش نیست')),
                );
              }
            },
            child: Icon(
              _currentSong != null && _isPlaying
                  ? Icons.stop
                  : Icons.music_note,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          drawer: CustomDrawer(onLogout: _showLogoutDialog),
        ),
      ),
    );
  }
}
