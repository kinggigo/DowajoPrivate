import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dowajo/components/models/medicine.dart';
import 'dart:convert';

class DatabaseHelper {
  static const _databaseName = "MedicineDatabase.db";
  static const _databaseVersion = 3;

  static const table = 'medicine_table';

  static const columnId = 'id';
  static const columnName = 'medicineName';
  static const columnPicture = 'medicinePicture';
  static const columnDay = 'medicineDay';
  static const columnRepeat = 'medicineRepeat';
  static const columnTime = 'medicineTime';
  static const columnTakenDates = 'takenDates';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      //onUpgrade: _onUpgrade,
    );
  }

  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (newVersion > oldVersion) {
  //     // 기존에 isTaken 컬럼이 없었다면 추가합니다.
  //     await db.execute(
  //         "ALTER TABLE $table ADD COLUMN isTaken INTEGER NOT NULL DEFAULT 0");
  //   }
  // }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPicture TEXT NOT NULL,
            $columnDay TEXT NOT NULL,
            $columnRepeat INTEGER NOT NULL,
            $columnTime TEXT NOT NULL,
            $columnTakenDates TEXT NOT NULL DEFAULT '{}'
          )
          ''');
  }

  Future<int> insert(Medicine medicine) async {
    Database? db = await instance.database;
    return await db!.insert(table, medicine.toMap());
  }

  Future<List<Medicine>> getAllMedicines() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(table);

    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        medicineName: maps[i]['medicineName'],
        medicinePicture: maps[i]['medicinePicture'],
        medicineDay: maps[i]['medicineDay'],
        medicineRepeat: maps[i]['medicineRepeat'],
        medicineTime: maps[i]['medicineTime'],
        takenDates: (jsonDecode(maps[i][columnTakenDates].toString()) as Map)
            .map((key, value) => MapEntry(key, value == 1)),
      );
    });
  }

  Future<int> update(Medicine medicine) async {
    Database? db = await instance.database;
    return await db!.update(
      table,
      medicine.toMap(),
      where: '$columnId = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> getIsTaken(int id, String dateStr) async {
    // 복용 완료 상태 가져오기
    final db = await database;
    final maps = await db!.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      Map<String, bool> takenDates =
          (jsonDecode(maps.first[columnTakenDates].toString()) as Map)
              .map((key, value) => MapEntry(key, value == 1));
      return takenDates[dateStr] ?? false;
    } else {
      return false;
    }
  }

  Future<void> updateIsTaken(int id, String dateStr, bool isTaken) async {
    Database? db = await instance.database;
    final maps = await db!.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      Map<String, bool> takenDates =
          (jsonDecode(maps.first[columnTakenDates].toString()) as Map)
              .map((key, value) => MapEntry(key, value == 1));
      takenDates[dateStr] = isTaken;
      await db.update(
        table,
        {
          columnTakenDates: jsonEncode(
              takenDates.map((key, value) => MapEntry(key, value ? 1 : 0)))
        },
        where: '$columnId = ?',
        whereArgs: [id],
      );
    }
  }

  Future<int?> getMedicineCountOnDay(String dayOfWeek) async {
    var db = await database;
    var result = await db!.rawQuery(
        'SELECT COUNT(*) FROM Medicine WHERE medicineDay LIKE "%$dayOfWeek%"');
    return Sqflite.firstIntValue(result);
  }

  Future<Map<String, bool>> getTakenDates(int id) async {
    // takenDates 가져오기
    final db = await database;
    final maps = await db!.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return (jsonDecode(maps.first[columnTakenDates].toString()) as Map)
          .map((key, value) => MapEntry(key, value == 1));
    } else {
      return {};
    }
  }

  Future<void> updateTakenDates(int id, Map<String, bool> takenDates) async {
    Database? db = await instance.database;
    await db!.update(
      table,
      {
        columnTakenDates: jsonEncode(
            takenDates.map((key, value) => MapEntry(key, value ? 1 : 0)))
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<Medicine> getMedicineFromDatabase(int id) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Medicine.fromMap(maps.first);
    } else {
      throw Exception('ID $id의 약이 데이터베이스에 없습니다.');
    }
  }

  Future<String> getTimeFromDatabase(int id) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first[columnTime];
    } else {
      throw Exception('ID $id의 약의 복용 시간 정보가 데이터베이스에 없습니다.');
    }
  }
}
