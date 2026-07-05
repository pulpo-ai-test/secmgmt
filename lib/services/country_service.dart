import "dart:convert";
import "package:flutter/services.dart" show rootBundle;
import "database.dart";

class CountryService {
  final AppDatabase _database;
  CountryService(this._database);

  Future<void> initializeAndSeed() async {
    final count = await _database.countryCount();
    if (count == 0) await _seedDatabase();
  }

  Future<void> _seedDatabase() async {
    final countries = await _loadCountriesFromJson();
    final rows = (countries as List).map((c) => {
      "country_code": c["country_code"] as String,
      "name": c["name"] as String,
      "region": c["region"] as String,
      "lat": (c["lat"] as num).toDouble(),
      "lng": (c["lng"] as num).toDouble(),
    }).toList();
    await _database.seedCountries(rows);
  }

  Future<dynamic> _loadCountriesFromJson() async {
    final bundle = await rootBundle.loadString("assets/countries.json");
    return jsonDecode(bundle);
  }

  Future<List<Map<String, dynamic>>> getAllCountries() {
    return _database.getAllCountries();
  }
}
