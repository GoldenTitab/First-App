import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int duration;
  final int releaseYear;
  final String coverUrl;
  final String audioUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.duration,
    required this.releaseYear,
    required this.coverUrl,
    required this.audioUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      artist: (json['artist'] as String?) ?? '',
      album: (json['album'] as String?) ?? '',
      genre: (json['genre'] as String?) ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      releaseYear: (json['releaseYear'] as num?)?.toInt() ?? 0,
      coverUrl: (json['coverUrl'] as String?) ?? '',
      audioUrl: (json['audioUrl'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'duration': duration,
      'releaseYear': releaseYear,
      'coverUrl': coverUrl,
      'audioUrl': audioUrl,
    };
  }

  Song copyWith({
    int? id,
    String? title,
    String? artist,
    String? album,
    String? genre,
    int? duration,
    int? releaseYear,
    String? coverUrl,
    String? audioUrl,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      genre: genre ?? this.genre,
      duration: duration ?? this.duration,
      releaseYear: releaseYear ?? this.releaseYear,
      coverUrl: coverUrl ?? this.coverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  List<Object?> get props => [id];
}
