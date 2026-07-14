import 'package:first_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/song_service.dart';
import '../services/player_service.dart';
import '../models/song.dart';
import '../utils/constants.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/song/song_list_view.dart';
import '../widgets/song/song_player_controls.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final SongService _songService = SongService();
  final PlayerService _playerService = PlayerService();

  bool _isLoggingOut = false;
  int _currentIndex = 0;

  List<Song> _songs = [];
  bool _isLoadingSongs = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _playerService.init();
    _fetchSongs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchSongs({bool forceRefresh = false}) async {
    setState(() {
      _isLoadingSongs = true;
      _errorMessage = null;
    });
    try {
      final songs = await _songService.fetchSongs(forceRefresh: forceRefresh);
      if (mounted) {
        setState(() {
          _songs = songs;
          _isLoadingSongs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoadingSongs = false;
        });
      }
    }
  }

  Widget _buildHomeTab() {
    return ListenableBuilder(
      listenable: _playerService,
      builder: (context, _) => SongListView(
        songs: _songs,
        isLoading: _isLoadingSongs,
        errorMessage: _errorMessage,
        onRetry: () => _fetchSongs(forceRefresh: true),
        currentSong: _playerService.currentSong,
        isPlaying: _playerService.isPlaying,
        currentPosition: _playerService.currentPosition,
        totalDuration: _playerService.totalDuration,
        onPlayPause: _playerService.playOrPause,
      ),
    );
  }

  Widget _buildLibraryTab() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.library_music, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(AppStrings.library),
      ],
    ),
  );

  Widget _buildFavoritesTab() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(AppStrings.favorites),
      ],
    ),
  );

  Widget _buildProfileTab() {
    final user = _authService.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 44,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? AppStrings.profile,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                user?.emailVerified == true
                    ? Icons.verified
                    : Icons.warning_amber,
                size: 16,
                color: user?.emailVerified == true
                    ? Colors.green
                    : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                user?.emailVerified == true ? 'تأیید شده' : 'تأیید نشده',
                style: TextStyle(
                  color: user?.emailVerified == true
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
      await _playerService.stop();
      await _authService.signOut();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.logoutError}${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      _buildLibraryTab(),
      _buildFavoritesTab(),
      _buildProfileTab(),
    ];

    return LoadingOverlay(
      isLoading: _isLoggingOut,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.home),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: AppStrings.logoutDialogTitle,
              onPressed: _isLoggingOut ? null : _showLogoutDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: pages[_currentIndex]),
            ListenableBuilder(
              listenable: _playerService,
              builder: (context, _) => SongPlayerControls(
                currentSong: _playerService.currentSong,
                isPlaying: _playerService.isPlaying,
                currentPosition: _playerService.currentPosition,
                totalDuration: _playerService.totalDuration,
                onPlayPause: _playerService.currentSong != null
                    ? () => _playerService.playOrPause(
                        _playerService.currentSong!,
                      )
                    : () {},
                onStop: _playerService.stop,
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
        drawer: CustomDrawer(onLogout: _showLogoutDialog),
      ),
    );
  }
}
