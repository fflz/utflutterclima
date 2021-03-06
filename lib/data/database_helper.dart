import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:utflutterclima/models/user.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;
  Future<Database> get db async => _db ??= await initDb();

  DatabaseHelper.internal();
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "data_flutter.db");

    ByteData data = await rootBundle.load(join('data', 'flutter.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    var ourDb = await openDatabase(path);
    return ourDb;
  }
}
