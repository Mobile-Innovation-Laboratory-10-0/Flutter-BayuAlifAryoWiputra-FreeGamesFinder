import 'package:get/get.dart';
import 'package:free_games_finder/app/data/models/favorite_mode.dart';
import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:free_games_finder/app/data/database/database_helper.dart';

class FavoriteController extends GetxController {
  var favoriteGames = <FavoriteModel>[].obs;

  @override
  void onInit() {
    loadFavorites();
    super.onInit();
  }

  Future<void> loadFavorites() async {
    final data = await DatabaseHelper.instance.getFavorites();

    favoriteGames.value = data.map((e) => FavoriteModel.fromMap(e)).toList();
  }

  /// CREATE / UPDATE
  Future<void> insertOrUpdateFavorite(
    GamesModel game,
    DateTime playDate,
  ) async {
    final now = DateTime.now().toIso8601String();

    final favorite = FavoriteModel(
      gameId: game.id,
      title: game.title,
      thumbnail: game.thumbnail,
      genre: game.genre,
      playDate: playDate.toIso8601String(),
      createdAt: now,
      updatedAt: now,
    );

    await DatabaseHelper.instance.insertFavorite(favorite);
    await loadFavorites();

    Get.snackbar("Success", "Favorite berhasil disimpan");
  }

  /// CHECK FAVORITE
  bool isFavorite(int gameId) {
    return favoriteGames.any((e) => e.gameId == gameId);
  }

  /// UPDATE PLAY DATE
  Future<void> updatePlayDate(FavoriteModel favorite, DateTime newDate) async {
    final updated = FavoriteModel(
      gameId: favorite.gameId,
      title: favorite.title,
      thumbnail: favorite.thumbnail,
      genre: favorite.genre,
      playDate: newDate.toIso8601String(),
      createdAt: favorite.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper.instance.updateFavorite(updated);
    await loadFavorites();

    Get.snackbar("Updated", "Play date berhasil diperbarui");
  }

  /// DELETE
  Future<void> deleteFavorite(int gameId) async {
    await DatabaseHelper.instance.deleteFavorite(gameId);
    await loadFavorites();
    Get.snackbar("Deleted", "Favorite dihapus");
  }
}
