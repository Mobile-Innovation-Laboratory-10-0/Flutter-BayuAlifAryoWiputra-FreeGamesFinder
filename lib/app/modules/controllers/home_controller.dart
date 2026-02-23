import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class HomeController extends GetxController {
  var gameList = <GamesModel>[].obs;
  var isLoading = true.obs;

  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  List<GamesModel> get filteredGames {
    if (searchQuery.value.isEmpty) {
      return gameList;
    } else {
      return gameList
          .where(
            (game) => game.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  void fetchGames() async {
    try {
      isLoading(true);
      var response = await Dio().get('https://www.freetogame.com/api/games');

      if (response.statusCode == 200) {
        List data = response.data;
        gameList.value = data.map((e) => GamesModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
