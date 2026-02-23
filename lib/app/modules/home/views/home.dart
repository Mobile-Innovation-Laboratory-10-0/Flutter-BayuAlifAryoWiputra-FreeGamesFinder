import 'package:flutter/material.dart';
import 'package:free_games_finder/app/modules/home/views/favorites.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart'; // Tambahkan import AuthController
import '../views/detail.dart';
import 'login.dart'; // Tambahkan import LoginView

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController()); // Panggil AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Game Finder 🎮'),
        centerTitle: true,
        actions: [
          // Tombol Favorit
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Validasi: Kalau belum login, tidak bisa buka daftar favorit
              if (!authController.isLoggedIn.value) {
                Get.snackbar("Akses Ditolak", "Silakan login terlebih dahulu untuk melihat favorit!");
                return;
              }
              Get.to(() => Favorites());
            },
          ),
          
          // Tombol Login / Logout Dinamis
          Obx(() => IconButton(
            icon: Icon(authController.isLoggedIn.value ? Icons.logout : Icons.login),
            tooltip: authController.isLoggedIn.value ? "Logout" : "Login",
            onPressed: () {
              if (authController.isLoggedIn.value) {
                // Jika sudah login, klik tombol ini akan logout
                authController.logout();
                Get.snackbar("Logout", "Berhasil keluar dari akun.");
              } else {
                // Jika belum login, arahkan ke halaman Login
                Get.to(() => LoginView());
              }
            },
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.gameList.length,
          itemBuilder: (context, index) {
            final game = controller.gameList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => const Detail(), arguments: game);
              },
              child: Card(
                color: const Color(0xFF1E1E1E),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: game.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            game.genre,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}