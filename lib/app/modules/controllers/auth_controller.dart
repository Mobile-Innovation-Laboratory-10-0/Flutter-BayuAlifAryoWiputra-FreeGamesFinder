import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:free_games_finder/app/data/database/database_helper.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus(); 
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('is_logged_in') ?? false;
    currentUsername.value = prefs.getString('username') ?? '';
  }

  Future<bool> login(String username, String password) async {
    final user = await DatabaseHelper.instance.loginUser(username, password);
    if (user != null) {
      isLoggedIn.value = true;
      currentUsername.value = user['username'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('username', user['username']);

      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final id = await DatabaseHelper.instance.registerUser(username, password);
    return id != -1; 
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    currentUsername.value = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('username');
  }
}