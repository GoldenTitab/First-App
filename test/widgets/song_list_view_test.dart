import 'package:first_app/models/song.dart';
import 'package:first_app/utils/constants.dart';
import 'package:first_app/widgets/song/song_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Song _song(int id, String title) => Song(
  id: id,
  title: title,
  artist: 'Artist',
  album: 'Album',
  genre: 'Pop',
  duration: 120,
  releaseYear: 2024,
  coverUrl: '',
  audioUrl: 'https://example.com/$id.mp3',
);

Widget _host({
  required List<Song> songs,
  bool isLoading = false,
  String? errorMessage,
  Set<int> favorites = const {},
  ValueChanged<Song>? onPlay,
  ValueChanged<Song>? onFavorite,
  VoidCallback? onRetry,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SongListView(
        songs: songs,
        isLoading: isLoading,
        errorMessage: errorMessage,
        onRetry: onRetry ?? () {},
        currentSong: null,
        isPlaying: false,
        position: ValueNotifier(Duration.zero),
        duration: ValueNotifier(Duration.zero),
        favoriteIds: favorites,
        onPlayPause: onPlay ?? (_) {},
        onToggleFavorite: onFavorite ?? (_) {},
      ),
    ),
  );
}

void main() {
  testWidgets('shows a spinner while loading', (tester) async {
    await tester.pumpWidget(_host(songs: const [], isLoading: true));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the error message and a working retry button', (
    tester,
  ) async {
    var retried = false;
    await tester.pumpWidget(
      _host(
        songs: const [],
        errorMessage: 'boom',
        onRetry: () => retried = true,
      ),
    );

    expect(find.text('boom'), findsOneWidget);
    await tester.tap(find.text(AppStrings.retry));
    expect(retried, isTrue);
  });

  testWidgets('shows the empty state', (tester) async {
    await tester.pumpWidget(_host(songs: const []));
    expect(find.text(AppStrings.musicNotFound), findsOneWidget);
  });

  testWidgets('lists songs; tapping plays, heart toggles favorite', (
    tester,
  ) async {
    final songs = [_song(1, 'First'), _song(2, 'Second')];
    Song? played;
    Song? toggled;

    await tester.pumpWidget(
      _host(
        songs: songs,
        favorites: const {2},
        onPlay: (s) => played = s,
        onFavorite: (s) => toggled = s,
      ),
    );

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget); // only song 2
    expect(find.byIcon(Icons.favorite_border), findsOneWidget); // song 1

    await tester.tap(find.text('First'));
    expect(played?.id, 1);

    await tester.tap(find.byIcon(Icons.favorite_border));
    expect(toggled?.id, 1);
  });
}
