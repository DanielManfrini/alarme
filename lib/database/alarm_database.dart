import 'package:flutter_application_1/models/alarm.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlarmDatabase {
  static final AlarmDatabase instance = AlarmDatabase._init();

  static Database? _database;

  AlarmDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('alarms.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Alarms (
      Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      Name TEXT NOT NULL,
      Time TEXT NOT NULL,
      Active INTEGER NOT NULL,
      "Type" INTEGER NOT NULL,
      CreatedIn TEXT,
      EditedIn TEXT
    )
    ''');
  }

  Future<Alarm> create(Alarm alarm) async {
    final db = await instance.database;

    final id = await db.insert('alarms', alarm.toMap());

    return alarm.copyWith(id: id);
  }

  Future<Alarm?> readAlarm(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'alarms',
      columns: ['Id', 'Name', 'Time', 'Active', "Type", 'CreatedIn', 'EditedIn'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Alarm.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Alarm>> readAllAlarms() async {
    final db = await instance.database;

    final result = await db.query('alarms');

    return result.map((json) => Alarm.fromMap(json)).toList();
  }

  Future<int> update(Alarm alarm) async {
    final db = await instance.database;

    return db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  // // Future<int> delete(int id) async {
  //   final db = await instance.database;

  //   return await db.delete(
  //     'alarms',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
