import "package:flutter_riverpod/flutter_riverpod.dart";
import "../services/country_service.dart";

final countriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final db = ref.read(databaseProvider);
  return db.getAllCountries();
});
