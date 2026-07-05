import "package:sqflite/sqflite.dart";

import "../models/advisory.dart";
import "database.dart";

class AdvisoryDatabase extends AppDatabase {
  static const String _tableName = "advisories";

  Future<void> upsertAdvisory(AdvisoryData advisory) async {
    final db = await database;
    await db.insert(
      _tableName,
      advisory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AdvisoryData?> getAdvisory(String countryCode, String source) async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: "country_code = ? AND source = ?",
      whereArgs: [countryCode.toUpperCase(), source],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return AdvisoryData.fromMap(rows.first);
  }

  Future<List<AdvisoryData>> getAllAdvisories() async {
    final db = await database;
    final rows = await db.query(_tableName, orderBy: "country_code ASC, source ASC");
    return rows.map(AdvisoryData.fromMap).toList();
  }

  Future<List<AdvisoryData>> getAdvisoriesByCountry(String countryCode) async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: "country_code = ?",
      whereArgs: [countryCode.toUpperCase()],
      orderBy: "source ASC",
    );
    return rows.map(AdvisoryData.fromMap).toList();
  }
}
