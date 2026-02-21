class GamesModel {
  final int id;
  final String title;
  final String thumbnail;
  final String description;
  final String genre;
  final String platform;
  final String publisher;

  // tambahan
  final String developer;
  final String releaseDate;
  final String gameUrl;

  GamesModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.gameUrl,
  });

  factory GamesModel.fromJson(Map<String, dynamic> json) {
    return GamesModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      thumbnail: json['thumbnail'] ?? '',
      description: json['short_description'] ?? '',
      genre: json['genre'] ?? 'Unknown',
      platform: json['platform'] ?? 'PC',
      publisher: json['publisher'] ?? 'Unknown',

      // mapping tambahan
      developer: json['developer'] ?? 'Unknown',
      releaseDate: json['release_date'] ?? 'Unknown',
      gameUrl: json['game_url'] ?? '',
    );
  }
}