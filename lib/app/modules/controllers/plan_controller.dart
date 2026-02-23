import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:free_games_finder/app/data/models/plan_model.dart';
import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:free_games_finder/app/data/database/database_helper.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';

class PlanController extends GetxController {
  var plannedGames = <PlanModel>[].obs;
  var searchQuery = ''.obs; 
  final AuthController auth = Get.find<AuthController>();

  List<PlanModel> get filteredPlans {
    if (searchQuery.value.isEmpty) return plannedGames;
    return plannedGames
        .where(
          (p) =>
              p.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    ever(auth.currentUsername, (_) => loadPlans());
    loadPlans();
  }

  Future<void> loadPlans() async {
    if (!auth.isLoggedIn.value) {
      plannedGames.clear();
      return;
    }
    final data = await DatabaseHelper.instance.getPlans(
      auth.currentUsername.value,
    );
    plannedGames.value = data.map((e) => PlanModel.fromMap(e)).toList();
  }

  Future<void> insertPlan(GamesModel game, DateTime playDate) async {
    final plan = PlanModel(
      gameId: game.id,
      username: auth.currentUsername.value,
      title: game.title,
      thumbnail: game.thumbnail,
      genre: game.genre,
      playDate: playDate.toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper.instance.insertPlan(plan);
    await loadPlans();
    Get.snackbar(
      "Success",
      "Jadwal main berhasil disimpan",
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
    );
  }

  Future<void> updatePlanDate(int gameId, DateTime newDate) async {
    await DatabaseHelper.instance.updatePlanDate(
      gameId,
      auth.currentUsername.value,
      newDate.toIso8601String(),
    );
    await loadPlans();
    Get.snackbar(
      "Updated",
      "Tanggal main berhasil diubah!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> deletePlan(int gameId) async {
    await DatabaseHelper.instance.deletePlan(
      gameId,
      auth.currentUsername.value,
    );
    await loadPlans();
    Get.snackbar(
      "Deleted",
      "Jadwal main dihapus",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  DateTime? getPlannedDate(int gameId) {
    try {
      final plan = plannedGames.firstWhere((e) => e.gameId == gameId);
      return DateTime.parse(plan.playDate);
    } catch (e) {
      return null;
    }
  }
}
