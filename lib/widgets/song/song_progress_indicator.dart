import 'package:flutter/material.dart';

class SongProgressIndicator extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;

  const SongProgressIndicator({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalDuration.inMilliseconds > 0
        ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
        : 0.0;

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      color: Theme.of(context).colorScheme.primary,
      minHeight: 3,
    );
  }
}
