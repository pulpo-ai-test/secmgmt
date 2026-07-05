import "package:sqflite/sqflite.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";

class AppDatabase {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "secmgmt.db");
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE IF NOT EXISTS countries (
          country_code TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          region TEXT NOT NULL,
          lat REAL NOT NULL,
          lng REAL NOT NULL
        )
      """);
    });
    return _db!;
  }

  Future<void> seedCountries(List<Map<String, dynamic>> countries) async {
    final db = await database;
    final batch = db.batch();
    for (final c in countries) {
      batch.insert("countries", c,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAllCountries() async {
    final db = await database;
    return db.query("countries", orderBy: "name ASC");
  }

  Future<Map<String, dynamic>?> getCountryByCode(String code) async {
    final db = await database;
    final rows = await db.query("countries",
        where: "country_code = ?", whereArgs: [code], limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> countryCount() async {
    final db = await database;
    final result = await db.rawQuery("SELECT COUNT(*) as cnt FROM countries");
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
