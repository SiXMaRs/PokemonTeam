import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/team.dart';
import 'team_list_page.dart';

class EditTeamPage extends StatefulWidget {
  final int teamIndex;
  const EditTeamPage({super.key, required this.teamIndex});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  late final TeamController c;
  bool hydrated = false;

  @override
  void initState() {
    super.initState();
    c = Get.isRegistered<TeamController>()
        ? Get.find<TeamController>()
        : Get.put(TeamController(), permanent: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hydrated && c.pokemons.isNotEmpty && c.teamsRx.length > widget.teamIndex) {
      final team = c.teamsRx[widget.teamIndex];
      c.teamName.value = (team['name'] ?? '').toString();
      c.selected.clear();
      final List prev = (team['pokemons'] as List?) ?? [];
      for (final p in prev) {
        final name = (p is Map && p['name'] != null) ? p['name'].toString() : '';
        final idx = c.pokemons.indexWhere((e) => e.name == name);
        if (idx != -1) c.selected.add(idx);
      }
      hydrated = true;
    }
  }

  Future<void> _save() async {
    final nameOk = c.teamName.value.trim().isNotEmpty;
    final picksOk = c.selected.length == 3;

    if (!nameOk || !picksOk) {
      Get.snackbar(
        'บันทึกไม่ได้',
        !nameOk && !picksOk
            ? 'กรุณากรอกชื่อทีม และเลือกโปเกมอนให้ครบ 3 ตัว'
            : (!nameOk ? 'กรุณากรอกชื่อทีม' : 'กรุณาเลือกโปเกมอนให้ครบ 3 ตัว'),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    await c.updateTeam(widget.teamIndex);
    Get.off(() => const TeamListPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('แก้ไขทีม: ${c.teamName.value.isEmpty ? '-' : c.teamName.value}')),
      ),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!hydrated && c.pokemons.isNotEmpty && c.teamsRx.length > widget.teamIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) => didChangeDependencies());
        }

        final indexes = c.filteredIndexes;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: TextEditingController(text: c.teamName.value)
                  ..selection = TextSelection.collapsed(offset: c.teamName.value.length),
                onChanged: (v) => c.teamName.value = v,
                decoration: InputDecoration(
                  labelText: 'ชื่อทีม',
                  hintText: 'เช่น Team Rocket',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // โชว์ตัวที่เลือก พร้อมปุ่มลบบนหัว
              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = c.selected.length > i;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (w, a) => ScaleTransition(scale: a, child: w),
                        child: filled
                            ? _SelectedWithRemove(
                                key: ValueKey('picked_edit_$i'),
                                name: c.pokemons[c.selected.elementAt(i)].name,
                                imageUrl: c.pokemons[c.selected.elementAt(i)].imageUrl,
                                onRemove: () {
                                  final removeIndex = c.selected.elementAt(i);
                                  c.selected.remove(removeIndex);
                                },
                              )
                            : const _EmptySlot(key: ValueKey('empty_edit')),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),

              // ปุ่ม Reset และ บันทึกทีม
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('บันทึกการแก้ไข'),
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    onPressed: c.resetSelection,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ค้นหา
              TextField(
                onChanged: (v) => c.search.value = v,
                decoration: InputDecoration(
                  hintText: 'ค้นหาโปเกมอน...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Grid รายการโปเกมอน
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.8),
                  itemCount: indexes.length,
                  itemBuilder: (_, i) {
                    final idx = indexes[i];
                    final p = c.pokemons[idx];
                    final selected = c.selected.contains(idx);
                    return GestureDetector(
                      onTap: () => c.toggle(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: selected ? Colors.green[200] : Colors.white,
                          border: Border.all(color: selected ? Colors.green : Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  p.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, size: 48, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(p.name, style: const TextStyle(fontSize: 14)),
                            Text('HP:${p.hp} ATK:${p.attack} DEF:${p.defense}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SelectedWithRemove extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onRemove;
  const _SelectedWithRemove({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
            ),
            Positioned(
              right: -8,
              top: -8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 70,
          child: Text(name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.person, color: Colors.grey[500], size: 40),
        ),
        const SizedBox(height: 4),
        const Text('ว่าง', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
