import 'package:get/get.dart';
import 'package:free_games_finder/app/data/database/database_helper.dart';

class AuthController extends GetxController {
  // Obx variables untuk memantau status login
  var isLoggedIn = false.obs;
  var currentUsername = ''.obs;

  Future<bool> login(String username, String password) async {
    final user = await DatabaseHelper.instance.loginUser(username, password);
    if (user != null) {
      isLoggedIn.value = true;
      currentUsername.value = user['username'];
      return true; // Berhasil login
    }
    return false; // Gagal login
  }

  Future<bool> register(String username, String password) async {
    final id = await DatabaseHelper.instance.registerUser(username, password);
    return id != -1; // Jika bukan -1, berarti sukses daftar
  }

  void logout() {
    isLoggedIn.value = false;
    currentUsername.value = '';
  }
}