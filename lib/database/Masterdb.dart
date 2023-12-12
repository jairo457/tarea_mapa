import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:tarea_mapa/Model/MarkModel.dart';

class MasterDB {
  static final nameDB = 'MAPDB';
  static final versionDB = 1;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

  FutureOr<void> _createTables(Database db, int version) {
    String query1 = '''CREATE TABLE tblMark(
        Id INTEGER PRIMARY KEY,
        lat VARCHAR(150),
        long VARCHAR(150),
        Name VARCHAR(100)
    );''';
    db.execute(query1);
  }

//Career---------------------------------------
  Future<int> INSERT_Mark(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> DELETE_Mark(String tblName, int id) async {
    var conexion = await database;
    return conexion!.delete(tblName, where: 'Id = ?', whereArgs: [id]);
  }

  Future<List<MarkModel>> GETALL_Mark() async {
    var conexion = await database;
    var result = await conexion!.query('tblMark');
    return result
        .map((task) => MarkModel.fromMap(task))
        .toList(); //muevete en cada elemento y genera la lista
  }
}
