class PlanModel {
  final int gameId;
  final String username;
  final String title;
  final String thumbnail;
  final String genre;
  final String playDate;
  final String createdAt;

  PlanModel({
    required this.gameId,
    required this.username,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.playDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'username': username,
      'title': title,
      'thumbnail': thumbnail,
      'genre': genre,
      'playDate': playDate,
      'createdAt': createdAt,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      gameId: map['gameId'],
      username: map['username'],
      title: map['title'],
      thumbnail: map['thumbnail'],
      genre: map['genre'],
      playDate: map['playDate'],
      createdAt: map['createdAt'],
    );
  }
}