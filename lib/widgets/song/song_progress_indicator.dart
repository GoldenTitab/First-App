import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Thin progress bar. It listens to the position/duration notifiers directly,
/// so only this small widget rebuilds while a song plays.
class SongProgressIndicator extends StatelessWidget {
  final ValueListenable<Duration> position;
  final ValueListenable<Duration> duration;

  const SongProgressIndicator({
    super.key,
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<Duration>(
      valueListenable: duration,
      builder: (_, total, _) => ValueListenableBuilder<Duration>(
        valueListenable: position,
        builder: (_, current, _) {
          final progress = total.inMilliseconds > 0
              ? (current.inMilliseconds / total.inMilliseconds)
                    .clamp(0.0, 1.0)
                    .toDouble()
              : 0.0;
          return LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: colorScheme.primary,
            minHeight: 3,
          );
        },
      ),
    );
  }
}
