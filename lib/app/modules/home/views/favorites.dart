import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/modules/controllers/favorite_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class Favorites extends StatelessWidget {
  Favorites({super.key});

  final FavoriteController controller =
      Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Games"),
      ),
      body: Obx(() {
        if (controller.favoriteGames.isEmpty) {
          return const Center(
            child: Text("Belum ada game favorit"),
          );
        }

        return ListView.builder(
          itemCount: controller.favoriteGames.length,
          itemBuilder: (context, index) {
            final fav = controller.favoriteGames[index];

            final formattedDate = DateFormat(
              'dd MMM yyyy',
            ).format(DateTime.parse(fav.playDate));

            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: fav.thumbnail,
                  width: 60,
                  fit: BoxFit.cover,
                ),

                title: Text(fav.title),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fav.genre),
                    const SizedBox(height: 4),
                    Text(
                      "Play Date: $formattedDate",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),

                /// EDIT & DELETE BUTTON
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_calendar,
                          color: Colors.green),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.parse(fav.playDate),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          controller.updatePlayDate(
                            fav,
                            picked,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () {
                        controller.deleteFavorite(
                            fav.gameId);
                      },
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