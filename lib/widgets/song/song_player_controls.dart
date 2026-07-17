import 'package:flutter/material.dart';
import '../../models/song.dart';
import 'song_progress_indicator.dart';

class SongPlayerControls extends StatelessWidget {
  final Song? currentSong;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;

  const SongPlayerControls({
    super.key,
    this.currentSong,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    if (currentSong == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
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
                      currentSong!.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong!.artist,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: onPlayPause,
              ),
              IconButton(icon: const Icon(Icons.stop), onPressed: onStop),
            ],
          ),
          SongProgressIndicator(
            currentPosition: currentPosition,
            totalDuration: totalDuration,
          ),
        ],
      ),
    );
  }
}
