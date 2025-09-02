import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/page/home.dart';
import 'team_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TeamController(), permanent: true);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('poke_teams_box'); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon Team (GetX)',
      initialBinding: AppBinding(), 
      home: const MyHomePage(title: "Home"), 
    );
  }
}
