import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/song.dart';
import '../../utils/constants.dart';
import 'song_seek_bar.dart';

/// Mini player shown above the bottom navigation bar on every tab.
class SongPlayerControls extends StatelessWidget {
  final Song? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final bool hasPrevious;
  final bool hasNext;
  final ValueListenable<Duration> position;
  final ValueListenable<Duration> duration;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onStop;
  final ValueChanged<Duration> onSeek;

  const SongPlayerControls({
    super.key,
    this.currentSong,
    required this.isPlaying,
    required this.isLoading,
    required this.hasPrevious,
    required this.hasNext,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onStop,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final song = currentSong;
    if (song == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song.artist,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: AppStrings.previous,
                icon: const Icon(Icons.skip_previous),
                onPressed: onPrevious,
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                )
              else
                IconButton(
                  iconSize: 32,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: onPlayPause,
                ),
              IconButton(
                tooltip: AppStrings.next,
                icon: const Icon(Icons.skip_next),
                onPressed: hasNext ? onNext : null,
              ),
              IconButton(icon: const Icon(Icons.stop), onPressed: onStop),
            ],
          ),
          SongSeekBar(position: position, duration: duration, onSeek: onSeek),
        ],
      ),
    );
  }
}
