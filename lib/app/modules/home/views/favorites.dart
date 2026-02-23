import 'package:flutter/material.dart';
import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:free_games_finder/app/modules/home/views/detail.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/favorite_controller.dart';
import '../../widgets/custom_search_bar.dart';

class Favorites extends StatelessWidget {
  Favorites({super.key});

  final FavoriteController controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomSearchBar(
            hintText: "Cari di favorit...",
            onChanged: (val) => controller.searchQuery.value = val,
          ),
          Expanded(
            child: Obx(() {
              final list = controller.filteredFavorites; 
              
              if (list.isEmpty) {
                return const Center(child: Text("Favorit kosong"));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final fav = list[index];
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      onTap: () {
                        final gameData = GamesModel(
                          id: fav.gameId,
                          title: fav.title,
                          thumbnail: fav.thumbnail,
                          genre: fav.genre,
                          description: "Detail lengkap bisa dilihat di menu Home.",
                          platform: "Tersedia", 
                          publisher: "Unknown",
                          developer: "Unknown",
                          releaseDate: "Unknown",
                          gameUrl: "",
                        );

                        Get.to(() => const Detail(), arguments: gameData);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: fav.thumbnail,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(
                        fav.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(fav.genre),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.pinkAccent,
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Hapus Favorit",
                            middleText: "Hapus ${fav.title} dari daftar favorit?",
                            textConfirm: "Ya, Hapus",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              controller.deleteFavorite(fav.gameId);
                              Get.back();
                            },
                            textCancel: "Batal",
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}