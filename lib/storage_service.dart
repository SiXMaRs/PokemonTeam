import 'package:get_storage/get_storage.dart';

const String BOX = 'poke_teams_box';
const String TEAMS_KEY = 'teams';

class StorageService {
  final GetStorage _box = GetStorage(BOX);

  List readTeams() {
    final raw = _box.read(TEAMS_KEY);
    return (raw is List) ? raw : <dynamic>[];
  }

  Future<void> writeTeams(List teams) async {
    await _box.write(TEAMS_KEY, teams);
  }

  void ensureInit() {
    _box.writeIfNull(TEAMS_KEY, <dynamic>[]);
  }

  void listenTeams(void Function(dynamic) cb) {
    _box.listenKey(TEAMS_KEY, cb);
  }
}
