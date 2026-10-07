import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/song.dart';
import '../../utils/constants.dart';
import 'song_progress_indicator.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final bool isCurrentSong;
  final bool isFavorite;
  final ValueListenable<Duration> position;
  final ValueListenable<Duration> duration;
  final VoidCallback onPlayPause;
  final VoidCallback onToggleFavorite;

  const SongListItem({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.isCurrentSong,
    required this.isFavorite,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = isCurrentSong && isPlaying;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: isActive ? 3 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCurrentSong
            ? BorderSide(color: colorScheme.primary, width: 1.5)
            : BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onPlayPause,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.coverUrl,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.music_note,
                      size: 28,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isCurrentSong
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${song.artist} \u2022 ${song.album}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurrentSong
                            ? colorScheme.primary.withValues(alpha: 0.7)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (isCurrentSong) ...[
                      const SizedBox(height: 6),
                      SongProgressIndicator(
                        position: position,
                        duration: duration,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    song.formattedDuration,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: isFavorite
                            ? AppStrings.removeFromFavorites
                            : AppStrings.addToFavorites,
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                      Icon(
                        isActive
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: isCurrentSong
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        size: 36,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
