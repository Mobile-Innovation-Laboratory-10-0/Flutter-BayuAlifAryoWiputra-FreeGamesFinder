import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Controllers
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';

// Views
import '../views/detail.dart';
import 'login.dart';
import 'favorites.dart'; // Import Favorites
import 'plan.dart'; // Import PlanView yang baru dibuat
// ... (imports tetap sama)
import '../../widgets/custom_search_bar.dart'; // Import widget baru

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController());
  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              authController.isLoggedIn.value
                  ? Icons.logout
                  : Icons.account_circle,
            ),
            color: authController.isLoggedIn.value
                ? Colors.redAccent
                : Colors.white,
            onPressed: () {
              if (authController.isLoggedIn.value) {
                authController.logout();
                Get.snackbar(
                  "Logout",
                  "Berhasil keluar.",
                  backgroundColor: Colors.black54,
                  colorText: Colors.white,
                );
                currentIndex.value = 0;
              } else {
                Get.to(() => LoginView());
              }
            },
          ),
          title: Text(
            currentIndex.value == 0
                ? 'Free Game Finder 🎮'
                : currentIndex.value == 1
                ? 'Favorite Games ❤️'
                : 'Plan Play 🗓️',
          ),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: currentIndex.value,
          children: [_buildHomeContent(), Favorites(), PlanView()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex.value,
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index != 0 && !authController.isLoggedIn.value) {
              Get.snackbar(
                "Akses Ditolak",
                "Login dulu yuk!",
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }
            currentIndex.value = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Plan Play",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        CustomSearchBar(
          hintText: "Cari game gratis...",
          onChanged: (val) => controller.searchQuery.value = val,
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value)
              return const Center(child: CircularProgressIndicator());

            // PAKAI FILTERED GAMES
            final games = controller.filteredGames;
            if (games.isEmpty)
              return const Center(
                child: Text(
                  "Game tidak ditemukan",
                  style: TextStyle(color: Colors.white),
                ),
              );

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return GestureDetector(
                  onTap: () => Get.to(() => const Detail(), arguments: game),
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
        ),
      ],
    );
  }
}
