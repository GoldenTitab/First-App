import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/song_service.dart';
import '../models/song.dart';
import '../utils/constants.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/loading_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final SongService _songService = SongService();
  bool _isLoggingOut = false;
  int _currentIndex = 0;

  List<Song> _songs = [];
  bool _isLoadingSongs = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
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

  Widget _buildHomePage() {
    if (_isLoadingSongs) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('خطا: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchSongs,
              child: const Text('تلاش مجدد'),
            ),
          ],
        ),
      );
    }
    if (_songs.isEmpty) {
      return const Center(child: Text('هیچ آهنگی یافت نشد.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.coverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 50),
              ),
            ),
            title: Text(song.title),
            subtitle: Text('${song.artist} - ${song.album}'),
            trailing: Text(
              '${(song.duration ~/ 60)}:${(song.duration % 60).toString().padLeft(2, '0')}',
            ),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('پخش: ${song.title}')));
            },
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog() async {
    if (_isLoggingOut) return;
    final bool? shouldLogout = await CustomDialog.showLogoutConfirmation(
      context,
    );
    if (shouldLogout ?? false) {
      await _performLogout();
    }
  }

  Future<void> _performLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.logOutError}${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<Widget> _pages = [
      _buildHomePage(),
      const Center(child: Text(AppStrings.bottomNavigatorLibrary)),
      const Center(child: Text(AppStrings.bottomNavigatorFavorites)),
      const Center(child: Text(AppStrings.bottomNavigatorProfile)),
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
          body: _pages[_currentIndex],
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorScheme.primary,
            onPressed: () => showText(context, "Kir Mikham"),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          drawer: CustomDrawer(onLogout: _showLogoutDialog),
        ),
      ),
    );
  }
}

void showText(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
}
