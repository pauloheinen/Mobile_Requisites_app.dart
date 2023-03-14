import 'package:flutter/foundation.dart';
import 'package:it_requires_app/Repository/ProjectRepository.dart';
import 'package:it_requires_app/Repository/UserRepository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Repository/RequisiteRepository.dart';

class DB {
  final _databaseName = "it_requirements";
  final _databaseVersion = 1;

  DB._();

  static final DB instance = DB._();

  static Database? _database;

  Future<Database?> get getDatabase async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(UserRepository.createTable);
    await db.execute(ProjectRepository.createTable);
    await db.execute(RequisiteRepository.createTable);

    db.batch().commit();
  }

  Future<int?> insert(String table, Map<String, dynamic> row) async {
    int? id;

    try {
      Database? db = await instance.getDatabase;
      id = await db?.insert(table, row);
      db?.batch().commit();

    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return id;
  }

  getData(String table) async {
    List<Map<String, dynamic>>? data = List.empty(growable: true);

    try {
      Database? db = await instance.getDatabase;

      data = await db?.query(table);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return data;
  }

  execute(String sql) async {
    List<Map<String, dynamic>>? data = List.empty(growable: true);

    try {
      Database? db = await instance.getDatabase;
      data = await db?.rawQuery(sql);
      db?.batch().commit();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return data;
  }
}
