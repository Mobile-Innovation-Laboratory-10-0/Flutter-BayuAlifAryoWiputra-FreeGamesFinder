class GamesModel{
  final int id;
  final String title;
  final String thumbnail;
  final String description;
  final String genre;
  final String platform;
  final String publisher;

  GamesModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.genre,
    required this.platform,
    required this.publisher,
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
    );
  }
}
