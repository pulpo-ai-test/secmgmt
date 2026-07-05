import "package:flutter_riverpod/flutter_riverpod.dart";
import "../services/database.dart";

final countriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final db = AppDatabase();
    return db.getAllCountries();
  } catch (e) {
    return [];
  }
});
