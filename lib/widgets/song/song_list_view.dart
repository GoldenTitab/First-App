import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/song.dart';
import '../../utils/constants.dart';
import 'song_list_item.dart';

class SongListView extends StatelessWidget {
  final List<Song> songs;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final Song? currentSong;
  final bool isPlaying;
  final ValueListenable<Duration> position;
  final ValueListenable<Duration> duration;
  final Set<int> favoriteIds;
  final ValueChanged<Song> onPlayPause;
  final ValueChanged<Song> onToggleFavorite;

  /// Pull-to-refresh handler (optional).
  final Future<void> Function()? onRefresh;

  /// Shown when [songs] is empty (defaults to "no songs found").
  final String emptyMessage;
  final IconData emptyIcon;

  const SongListView({
    super.key,
    required this.songs,
    required this.isLoading,
    this.errorMessage,
    required this.onRetry,
    this.currentSong,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.favoriteIds,
    required this.onPlayPause,
    required this.onToggleFavorite,
    this.onRefresh,
    this.emptyMessage = AppStrings.musicNotFound,
    this.emptyIcon = Icons.music_off,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              const Text(
                AppStrings.fetchSongsListError,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (songs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emptyIcon,
                size: 64,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(emptyMessage, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    final list = ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongListItem(
          key: ValueKey(song.id),
          song: song,
          isPlaying: isPlaying,
          isCurrentSong: currentSong == song,
          isFavorite: favoriteIds.contains(song.id),
          position: position,
          duration: duration,
          onPlayPause: () => onPlayPause(song),
          onToggleFavorite: () => onToggleFavorite(song),
        );
      },
    );

    final refresh = onRefresh;
    return refresh == null
        ? list
        : RefreshIndicator(onRefresh: refresh, child: list);
  }
}
