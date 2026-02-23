import 'package:flutter/material.dart';
import 'package:free_games_finder/app/data/models/games_model.dart';
import 'package:free_games_finder/app/modules/home/views/detail.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/modules/controllers/plan_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:free_games_finder/app/modules/widgets/custom_search_bar.dart';

class PlanView extends StatelessWidget {
  PlanView({super.key});

  final PlanController controller = Get.put(PlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomSearchBar(
            hintText: "Cari jadwal main...",
            onChanged: (value) => controller.searchQuery.value = value,
          ),
          Expanded(
            child: Obx(() {
              final list = controller.filteredPlans;

              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    "Tidak ada jadwal ditemukan",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final plan = list[index];
                  final formattedDate = DateFormat(
                    'dd MMM yyyy',
                  ).format(DateTime.parse(plan.playDate));

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      onTap: () {
                        final gameArgument = GamesModel(
                          id: plan.gameId,
                          title: plan.title,
                          thumbnail: plan.thumbnail,
                          genre: plan.genre,
                          description:
                              "Detail lengkap dapat dilihat melalui halaman Home.",
                          platform: "PC / Browser",
                          publisher: "N/A",
                          developer: "N/A",
                          releaseDate: "N/A",
                          gameUrl: "",
                        );

                        Get.to(() => const Detail(), arguments: gameArgument);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: plan.thumbnail,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(
                        plan.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.genre),
                          const SizedBox(height: 4),
                          Text(
                            "Jadwal: $formattedDate",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_calendar,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(plan.playDate),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );

                              if (picked != null) {
                                controller.updatePlanDate(plan.gameId, picked);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Tambahkan konfirmasi hapus sederhana agar lebih pro
                              Get.defaultDialog(
                                title: "Hapus",
                                middleText: "Hapus jadwal ${plan.title}?",
                                onConfirm: () {
                                  controller.deletePlan(plan.gameId);
                                  Get.back();
                                },
                                textCancel: "Batal",
                              );
                            },
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
      ),
    );
  }
}
