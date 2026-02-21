class FavoriteModel {
  final int gameId;
  final String title;
  final String thumbnail;
  final String genre;
  final String playDate;
  final String createdAt;
  final String updatedAt;

  FavoriteModel({
    required this.gameId,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.playDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'title': title,
      'thumbnail': thumbnail,
      'genre': genre,
      'playDate': playDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      gameId: map['gameId'],
      title: map['title'],
      thumbnail: map['thumbnail'],
      genre: map['genre'],
      playDate: map['playDate'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}