import 'database.dart';

class AdvisoryService {
  final AppDatabase _db;
  AdvisoryService(this._db);

  Future<Map<String, int>> loadAdvisories() async {
    final advisories = await _db.getAllAdvisories();
    final Map<String, int> result = {};
    for (final a in advisories) {
      final code = a['country_code'] as String;
      final level = a['advisory_level'] as int;
      final current = result[code] ?? 0;
      if (level > current) {
        result[code] = level;
      }
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getAdvisoriesForCountry(String countryCode) async {
    return _db.getAdvisoriesForCountry(countryCode);
  }

  Future<int> getConsolidatedLevel(String countryCode) async {
    final advisories = await _db.getAdvisoriesForCountry(countryCode);
    int highest = 0;
    for (final a in advisories) {
      final level = a['advisory_level'] as int;
      if (level > highest) highest = level;
    }
    return highest;
  }
}
