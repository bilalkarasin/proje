import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static final Databasehelper instance = Databasehelper._instance();
  static Database? _database;

  Databasehelper._instance();

  Future<Database> get db async {
    await initDb();
    return _database!;
  }

  Future<void> initDb() async {
    String? databasesPath;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      databasesPath = await getDatabasesPath();
    } else {
      databaseFactory = databaseFactoryFfi;
      databasesPath = Platform.isIOS
          ? (await getLibraryDirectory()).path
          : (await getApplicationDocumentsDirectory()).path;
    }

    String path = join(databasesPath, 'my.db');

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static void _onCreate(Database db, int version) async {
    String sqlQuery =
        "CREATE TABLE person (id INTEGER PRIMARY KEY AUTOINCREMENT, ad STRING, soyad STRING, boy INTEGER, kilo REAL, yas INTEGER, cinsiyet STRING)";
    await db.execute(sqlQuery);
  }

  static Future<int> insert(String table, Map<String, dynamic> values) async {
    if (_database == null) {
      throw Exception("Database henüz başlatılmadı.");
    }
    return await _database!.insert(table, values);
  }

  static Future<int> update(
      String table,
      Map<String, dynamic> values, {
        String? where,
        List<Object?>? whereArgs,
      }) async {
    if (_database == null) {
      throw Exception("Database henüz başlatılmadı.");
    }
    return await _database!.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<int> delete(
      String table, {
        required String where,
        required List<Object?> whereArgs,
      }) async {
    if (_database == null) {
      throw Exception("Database henüz başlatılmadı.");
    }
    return await _database!.delete(table, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    if (_database == null) {
      throw Exception("Database henüz başlatılmadı.");
    }
    return await _database!.query(table);
  }

  static void close() {
    _database?.close();
  }
}
