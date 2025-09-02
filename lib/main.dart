import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'myapp.dart';
import 'package:myapp/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(BOX);
  runApp(const MyApp());
}
