class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int duration;
  final int releaseYear;
  final String coverUrl;
  final String audioUrl;

  Song({
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
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      genre: json['genre'],
      duration: json['duration'],
      releaseYear: json['releaseYear'],
      coverUrl: json['coverUrl'],
      audioUrl: json['audioUrl'],
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
