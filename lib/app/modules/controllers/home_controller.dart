import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class HomeController extends GetxController {
  var gameList = <GamesModel>[].obs;
  var isLoading = true.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchGames(); 
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
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading(false);
    }
  }
}