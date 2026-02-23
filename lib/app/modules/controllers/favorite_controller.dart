import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/data/models/favorite_mode.dart';
import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:free_games_finder/app/data/database/database_helper.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';

class FavoriteController extends GetxController {
  var favoriteGames = <FavoriteModel>[].obs;
  var searchQuery = ''.obs;

  List<FavoriteModel> get filteredFavorites => favoriteGames
      .where(
        (fav) =>
            fav.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
      )
      .toList();

  final AuthController auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    ever(auth.currentUsername, (_) => loadFavorites());
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    if (!auth.isLoggedIn.value) {
      favoriteGames.clear();
      return;
    }
    final data = await DatabaseHelper.instance.getFavorites(
      auth.currentUsername.value,
    );
    favoriteGames.value = data.map((e) => FavoriteModel.fromMap(e)).toList();
  }

  Future<void> toggleFavorite(GamesModel game) async {
    final user = auth.currentUsername.value;

    if (isFavorite(game.id)) {
      await DatabaseHelper.instance.deleteFavorite(game.id, user);
      Get.snackbar(
        "Removed",
        "Game dihapus dari favorit",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } else {
      final now = DateTime.now().toIso8601String();
      final favorite = FavoriteModel(
        gameId: game.id,
        username: user, 
        title: game.title,
        thumbnail: game.thumbnail,
        genre: game.genre,
        createdAt: now,
        updatedAt: now,
      );
      await DatabaseHelper.instance.insertFavorite(favorite);
      Get.snackbar(
        "Success",
        "Game ditambahkan ke favorit",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
    await loadFavorites();
  }

  bool isFavorite(int gameId) {
    return favoriteGames.any((e) => e.gameId == gameId);
  }

  Future<void> deleteFavorite(int gameId) async {
    await DatabaseHelper.instance.deleteFavorite(
      gameId,
      auth.currentUsername.value,
    );
    await loadFavorites();
    Get.snackbar(
      "Deleted",
      "Game dihapus dari daftar favorit",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}
