import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/song.dart';
import '../services/auth_service.dart';
import '../services/favorites_service.dart';
import '../services/player_service.dart';
import '../services/song_service.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../utils/exception_handler.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/song/song_list_view.dart';
import '../widgets/song/song_player_controls.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _favoritesTab = 2;

  final AuthService _authService = AuthService();
  final SongService _songService = SongService();
  final PlayerService _playerService = PlayerService();
  final FavoritesService _favorites = FavoritesService();

  bool _isLoggingOut = false;
  int _currentIndex = 0;

  List<Song> _songs = [];
  bool _isLoadingSongs = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _playerService.init();
    _playerService.addListener(_onPlayerChanged);

    final uid = _authService.currentUser?.uid;
    if (uid != null) unawaited(_favorites.load(uid));

    _fetchSongs();
  }

  @override
  void dispose() {
    // Only detach our own listener. PlayerService is an app-wide singleton and
    // must NOT be disposed here (it would break playback after re-login).
    _playerService.removeListener(_onPlayerChanged);
    super.dispose();
  }

  void _onPlayerChanged() {
    final error = _playerService.error;
    if (error == null || !mounted) return;
    _playerService.clearError();
    _showSnackBar(error, isError: true);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  /// [silent] is used by pull-to-refresh: keep the current list on screen and
  /// report a failure with a snack bar instead of replacing it with an error.
  Future<void> _fetchSongs({
    bool forceRefresh = false,
    bool silent = false,
  }) async {
    if (!silent) {
      setState(() {
        _isLoadingSongs = true;
        _errorMessage = null;
      });
    }
    try {
      final songs = await _songService.fetchSongs(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _songs = songs;
        _isLoadingSongs = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      final message = ExceptionHandler.messageFor(e);
      if (silent) {
        _showSnackBar(message, isError: true);
      } else {
        setState(() {
          _errorMessage = message;
          _isLoadingSongs = false;
        });
      }
    }
  }

  Widget _buildSongsTab({bool favoritesOnly = false}) {
    return ListenableBuilder(
      listenable: Listenable.merge([_playerService, _favorites]),
      builder: (context, _) {
        final songs = favoritesOnly
            ? _songs.where((s) => _favorites.isFavorite(s.id)).toList()
            : _songs;

        return SongListView(
          songs: songs,
          isLoading: _isLoadingSongs,
          errorMessage: _errorMessage,
          onRetry: () => _fetchSongs(forceRefresh: true),
          currentSong: _playerService.currentSong,
          isPlaying: _playerService.isPlaying,
          position: _playerService.positionNotifier,
          duration: _playerService.durationNotifier,
          favoriteIds: _favorites.ids,
          onPlayPause: (song) => _playerService.playOrPause(song, queue: songs),
          onToggleFavorite: (song) => _favorites.toggle(song.id),
          onRefresh: favoritesOnly
              ? null
              : () => _fetchSongs(forceRefresh: true, silent: true),
          emptyMessage: favoritesOnly
              ? AppStrings.noFavorites
              : AppStrings.musicNotFound,
          emptyIcon: favoritesOnly ? Icons.favorite_border : Icons.music_off,
        );
      },
    );
  }

  Widget _buildLibraryTab() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.library,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final user = _authService.currentUser;
    final colorScheme = Theme.of(context).colorScheme;
    final verified = user?.emailVerified == true;
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
                verified ? Icons.verified : Icons.warning_amber,
                size: 16,
                color: verified ? colorScheme.primary : colorScheme.error,
              ),
              const SizedBox(width: 4),
              Text(
                verified ? AppStrings.approved : AppStrings.notApproved,
                style: TextStyle(
                  color: verified ? colorScheme.primary : colorScheme.error,
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
      _favorites.clear();
      await _authService.signOut();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          '${AppStrings.logoutError}${ExceptionHandler.messageFor(e)}',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoggingOut,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.home),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: AppStrings.logoutDialogTitle,
              onPressed: _isLoggingOut ? null : _showLogoutDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            // IndexedStack keeps every tab alive, so scroll position and state
            // survive tab switches.
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildSongsTab(),
                  _buildLibraryTab(),
                  _buildSongsTab(favoritesOnly: true),
                  _buildProfileTab(),
                ],
              ),
            ),
            ListenableBuilder(
              listenable: _playerService,
              builder: (context, _) => SongPlayerControls(
                currentSong: _playerService.currentSong,
                isPlaying: _playerService.isPlaying,
                isLoading: _playerService.isLoading,
                hasPrevious: _playerService.hasPrevious,
                hasNext: _playerService.hasNext,
                position: _playerService.positionNotifier,
                duration: _playerService.durationNotifier,
                onPlayPause: _playerService.togglePlayPause,
                onPrevious: _playerService.previous,
                onNext: _playerService.next,
                onStop: _playerService.stop,
                onSeek: _playerService.seek,
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
        drawer: CustomDrawer(
          onLogout: _showLogoutDialog,
          onOpenFavorites: () => setState(() => _currentIndex = _favoritesTab),
        ),
      ),
    );
  }
}
