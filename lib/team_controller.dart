import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/page/EditTeam.dart';
import 'package:myapp/pokemon.dart';
import 'package:myapp/storage_service.dart';

class TeamController extends GetxController {
  final storage = StorageService();

  // state
  final loading = true.obs;
  final search = ''.obs;
  final teamName = ''.obs;

  final pokemons = <Pokemon>[].obs;                 
  final selected = <int>{}.obs;                    
  final teamsRx = <Map<String, dynamic>>[].obs;     

  @override
  void onInit() {
    super.onInit();
    storage.ensureInit();

    // sync teams จาก storage -> RxList
    _reloadTeamsFromStorage();
    storage.listenTeams((_) => _reloadTeamsFromStorage());

    // โหลดโปเกมอนรอบแรก
    fetchPokemons();
  }

  void _reloadTeamsFromStorage() {
    final raw = storage.readTeams();
    teamsRx.assignAll(List<Map<String, dynamic>>.from(raw));
  }
  // โหลดข้อมูลโปเกมอนจาก API
  Future<void> fetchPokemons() async {
    try {
      loading.value = true;
      pokemons.clear();

      final res = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=30'));
      if (res.statusCode != 200) {
        loading.value = false;
        Get.snackbar('ผิดพลาด', 'โหลดข้อมูลไม่สำเร็จ: ${res.statusCode}');
        return;
      }

      final data = json.decode(res.body) as Map<String, dynamic>;
      final List results = data['results'];

      final list = <Pokemon>[];
      for (final item in results) {
        final d = await http.get(Uri.parse(item['url']));
        if (d.statusCode == 200) {
          final detail = json.decode(d.body);
          final id = detail['id'];
          final stats = detail['stats'];
          list.add(
            Pokemon(
              name: detail['name'],
              imageUrl:
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
              hp: stats[0]['base_stat'],
              attack: stats[1]['base_stat'],
              defense: stats[2]['base_stat'],
            ),
          );
        }
      }

      pokemons.assignAll(list);
    } catch (e) {
      Get.snackbar('ผิดพลาด', '$e');
    } finally {
      loading.value = false;
    }
  }

  // เลือก/ยกเลิกเลือก
  void toggle(int index) {
    if (selected.contains(index)) {
      selected.remove(index);
    } else if (selected.length < 3) {
      selected.add(index);
    }
  }

  void resetSelection() => selected.clear();

  // บันทึกทีมใหม่
  Future<void> saveTeam() async {
    if (teamName.value.trim().isEmpty) {
      Get.snackbar('แจ้งเตือน', 'กรุณากรอกชื่อทีม');
      return;
    }
    if (selected.length != 3) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเลือกโปเกมอนให้ครบ 3 ตัว');
      return;
    }

    final current = storage.readTeams();
    final teamPokemons =
        selected.map((i) => pokemons[i].toJson()).toList(growable: false);

    current.add({'name': teamName.value.trim(), 'pokemons': teamPokemons});
    await storage.writeTeams(current);

    teamsRx.assignAll(List<Map<String, dynamic>>.from(current));
    Get.snackbar('สำเร็จ', 'บันทึกทีมแล้ว');
  }

  // อัปเดตทีมเดิม (สำหรับหน้าแก้ไข)
  Future<void> updateTeam(int index) async {
    final all = storage.readTeams();
    if (index < 0 || index >= all.length) {
      Get.snackbar('ผิดพลาด', 'ไม่พบทีมที่ต้องการบันทึก');
      return;
    }
    if (teamName.value.trim().isEmpty) {
      Get.snackbar('แจ้งเตือน', 'กรุณากรอกชื่อทีม');
      return;
    }
    if (selected.length != 3) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเลือกโปเกมอนให้ครบ 3 ตัว');
      return;
    }

    all[index]['name'] = teamName.value.trim();
    all[index]['pokemons'] =
        selected.map((i) => pokemons[i].toJson()).toList(growable: false);

    await storage.writeTeams(all);
    teamsRx.assignAll(List<Map<String, dynamic>>.from(all));
    Get.snackbar('สำเร็จ', 'บันทึกการแก้ไขแล้ว');
  }

  List<int> get filteredIndexes {
    final q = search.value.toLowerCase();
    final out = <int>[];
    for (var i = 0; i < pokemons.length; i++) {
      if (pokemons[i].name.contains(q)) out.add(i);
    }
    return out;
  }
}