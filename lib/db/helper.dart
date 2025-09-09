import 'package:pocketbase/pocketbase.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  final PocketBase client = PocketBase('http://127.0.0.1:8090');}