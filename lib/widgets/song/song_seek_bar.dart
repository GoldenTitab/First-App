import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/format.dart';

/// Draggable seek bar with elapsed / total time labels.
///
/// While the user drags, the slider follows the finger; the actual seek is only
/// performed once, when the drag ends.
class SongSeekBar extends StatefulWidget {
  final ValueListenable<Duration> position;
  final ValueListenable<Duration> duration;
  final ValueChanged<Duration> onSeek;

  const SongSeekBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<SongSeekBar> createState() => _SongSeekBarState();
}

class _SongSeekBarState extends State<SongSeekBar> {
  double? _dragValue; // milliseconds, only while dragging

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return ValueListenableBuilder<Duration>(
      valueListenable: widget.duration,
      builder: (_, total, _) => ValueListenableBuilder<Duration>(
        valueListenable: widget.position,
        builder: (_, current, _) {
          final totalMs = total.inMilliseconds.toDouble();
          final maxValue = totalMs > 0 ? totalMs : 1.0;
          final value = (_dragValue ?? current.inMilliseconds.toDouble())
              .clamp(0.0, maxValue)
              .toDouble();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(
                  value: value,
                  max: maxValue,
                  onChanged: totalMs > 0
                      ? (v) => setState(() => _dragValue = v)
                      : null,
                  onChangeEnd: (v) {
                    widget.onSeek(Duration(milliseconds: v.round()));
                    setState(() => _dragValue = null);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(Duration(milliseconds: value.round())),
                      style: textStyle,
                    ),
                    Text(formatDuration(total), style: textStyle),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
