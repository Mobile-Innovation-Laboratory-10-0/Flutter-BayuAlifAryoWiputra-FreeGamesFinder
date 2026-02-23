import 'package:flutter/material.dart';
import 'package:free_games_finder/app/data/database/database_helper.dart';
import 'package:free_games_finder/app/modules/controllers/favorite_controller.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';
import 'package:free_games_finder/app/modules/controllers/plan_controller.dart';
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

  late GamesModel game;
  final TextEditingController commentController = TextEditingController();
  List<Map<String, dynamic>> commentsList = [];
  bool isLoadingComments = true;

  final authController = Get.find<AuthController>();
  final favoriteController = Get.find<FavoriteController>();
  final planController = Get.find<PlanController>();

  @override
  void initState() {
    super.initState();

    game = Get.arguments as GamesModel;

    _loadComments();

    selectedDate = planController.getPlannedDate(game.id);
  }

  Future<void> _loadComments() async {
    final data = await DatabaseHelper.instance.getCommentsByGame(game.id);
    if (mounted) {
      setState(() {
        commentsList = data;
        isLoadingComments = false;
      });
    }
  }

  Future<void> _submitComment() async {
    if (commentController.text.trim().isEmpty) return;

    if (!authController.isLoggedIn.value) {
      Get.snackbar(
        "Gagal",
        "Mas Bayu harus login dulu untuk memberi komentar!",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    await DatabaseHelper.instance.addComment(
      game.id,
      authController.currentUsername.value,
      commentController.text.trim(),
    );

    commentController.clear();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
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
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 50),
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
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        const Spacer(),
                        Obx(() {
                          final isFav = favoriteController.isFavorite(game.id);
                          return IconButton(
                            iconSize: 32,
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.pinkAccent : Colors.grey,
                            ),
                            onPressed: () {
                              if (!authController.isLoggedIn.value) {
                                Get.snackbar("Akses Ditolak", "Login dulu ya!");
                                return;
                              }
                              favoriteController.toggleFavorite(game);
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Plan Play",
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
                                ? "Belum ada jadwal main"
                                : "Jadwal: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!authController.isLoggedIn.value) {
                              Get.snackbar(
                                "Akses Ditolak",
                                "Login dulu untuk buat jadwal!",
                              );
                              return;
                            }
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              setState(() => selectedDate = picked);
                              planController.insertPlan(game, picked);
                            }
                          },
                          child: Text(
                            selectedDate == null
                                ? "Set Tanggal"
                                : "Ubah Tanggal",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                    _buildInfoRow('Developer', game.developer),
                    const SizedBox(height: 8),
                    _buildInfoRow('Publisher', game.publisher),
                    const SizedBox(height: 8),
                    _buildInfoRow('Release Date', game.releaseDate),
                    const SizedBox(height: 24),
                    const Divider(thickness: 2),
                    const SizedBox(height: 16),
                    const Text(
                      "Komentar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => TextField(
                              controller: commentController,
                              enabled: authController.isLoggedIn.value,
                              decoration: InputDecoration(
                                hintText: authController.isLoggedIn.value
                                    ? "Tulis komentar..."
                                    : "Login dulu untuk komentar",
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                          onPressed: _submitComment,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    isLoadingComments
                        ? const Center(child: CircularProgressIndicator())
                        : commentsList.isEmpty
                        ? const Center(child: Text("Belum ada komentar."))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: commentsList.length,
                            itemBuilder: (context, index) {
                              final c = commentsList[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: Text(
                                      c['username'][0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    c['username'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(c['comment']),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
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
