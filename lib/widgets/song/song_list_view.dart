import 'package:flutter/material.dart';
import '../../models/song.dart';
import 'song_list_item.dart';
import '../../utils/constants.dart';

class SongListView extends StatelessWidget {
  final List<Song> songs;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final Song? currentSong;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final Function(Song) onPlayPause;

  const SongListView({
    super.key,
    required this.songs,
    required this.isLoading,
    this.errorMessage,
    required this.onRetry,
    this.currentSong,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              const Text(
                AppStrings.getMusicListError,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(AppStrings.musicNotFounded),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final bool isCurrentSong = currentSong == song;

        return SongListItem(
          song: song,
          isPlaying: isPlaying,
          isCurrentSong: isCurrentSong,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
          onPlayPause: () => onPlayPause(song),
        );
      },
    );
  }
}
