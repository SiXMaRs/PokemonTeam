import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/EditTeam.dart';
import 'package:myapp/page/playerselection.dart';
import 'package:myapp/team_controller.dart';

class TeamListPage extends StatelessWidget {
  const TeamListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<TeamController>()
        ? Get.find<TeamController>()
        : Get.put(TeamController(), permanent: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทีมที่บันทึกไว้'),
        actions: [
          IconButton(
            tooltip: 'รีโหลดโปเกมอน',
            icon: const Icon(Icons.refresh),
            onPressed: c.fetchPokemons,
          ),
        ],
      ),
      body: Obx(() {
        final teams = c.teamsRx; 
        if (teams.isEmpty) {
          return const Center(child: Text('ยังไม่มีทีมที่บันทึกไว้'));
        }
        return ListView.builder(
          itemCount: teams.length,
          itemBuilder: (_, i) {
            final t = teams[i];
            final name = (t['name'] ?? '').toString();
            final pokes = (t['pokemons'] as List?) ?? [];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(name.isEmpty ? '(ไม่มีชื่อทีม)' : name),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pokes
                        .map((p) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  (p['imageUrl'] ?? '').toString(),
                                  width: 40, height: 40, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 40, height: 40,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, size: 18, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ))
                        .cast<Widget>()
                        .toList(),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Get.to(() => EditTeamPage(teamIndex: i)),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          c.resetSelection();
          c.teamName.value = '';
          Get.to(() => const PlayerSelectionPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}