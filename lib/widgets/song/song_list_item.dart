import 'package:flutter/material.dart';
import '../../models/song.dart';
import 'song_progress_indicator.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final bool isCurrentSong;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onPlayPause;

  const SongListItem({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.isCurrentSong,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isCurrentSong && isPlaying ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCurrentSong && isPlaying
            ? BorderSide(color: colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            song.coverUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: const Icon(Icons.music_note, size: 30),
            ),
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
            fontWeight: isCurrentSong && isPlaying
                ? FontWeight.bold
                : FontWeight.normal,
            color: isCurrentSong && isPlaying ? colorScheme.primary : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${song.artist} - ${song.album}',
              style: TextStyle(
                color: isCurrentSong && isPlaying
                    ? colorScheme.primary.withValues(alpha: 0.7)
                    : null,
              ),
            ),
            if (isCurrentSong && isPlaying) ...[
              const SizedBox(height: 4),
              SongProgressIndicator(
                currentPosition: currentPosition,
                totalDuration: totalDuration,
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(song.duration ~/ 60)}:${(song.duration % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                isCurrentSong && isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: isCurrentSong && isPlaying
                    ? colorScheme.primary
                    : Colors.grey[600],
                size: 36,
              ),
              onPressed: onPlayPause,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        onTap: onPlayPause,
      ),
    );
  }
}
