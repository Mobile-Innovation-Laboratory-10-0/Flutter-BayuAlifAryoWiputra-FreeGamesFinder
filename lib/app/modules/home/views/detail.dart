import 'package:flutter/material.dart';
// import 'package:free_games_finder/app/data/database/database_helper.dart';
// import 'package:free_games_finder/app/data/models/favorite_mode.dart';
import 'package:free_games_finder/app/modules/controllers/favorite_controller.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:free_games_finder/app/data/models/games_model.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final GamesModel game = Get.arguments as GamesModel;
    final favoriteController = Get.put(FavoriteController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                game.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: game.thumbnail,
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Genre & Platform
                    Row(
                      children: [
                        Chip(
                          backgroundColor: Colors.blueGrey,
                          label: Text(
                            game.genre,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          backgroundColor: Colors.blueGrey,
                          label: Text(
                            game.platform,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ================= PLAY DATE =================
                    const Text(
                      "Play Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? "Belum pilih tanggal"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text("Pilih Tanggal"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// DESCRIPTION
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      game.description,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    _buildInfoRow('Developer', game.developer),
                    const SizedBox(height: 8),
                    _buildInfoRow('Publisher', game.publisher),
                    const SizedBox(height: 8),
                    _buildInfoRow('Release Date', game.releaseDate),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      /// ================= FAB =================
      floatingActionButton: Obx(() {
        final isFav = favoriteController.isFavorite(game.id);

        return FloatingActionButton(
          tooltip: "Add to Favorite",
          onPressed: () {
            if (selectedDate == null) {
              Get.snackbar(
                "Tanggal belum dipilih",
                "Silakan pilih tanggal mau main dulu",
              );
              return;
            }

            favoriteController.insertOrUpdateFavorite(
              game,
              selectedDate!,
            );
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}