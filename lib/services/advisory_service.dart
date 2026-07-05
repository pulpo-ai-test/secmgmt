import "package:dio/dio.dart";

import "../models/advisory.dart";
import "../services/advisory_database.dart";
import "../services/sources/australia_dfat.dart";
import "../services/sources/canada_gac.dart";
import "../services/sources/france_diplomatie.dart";
import "../services/sources/germany_aa.dart";
import "../services/sources/uk_fcdo.dart";
import "../services/sources/us_state_dept.dart";
import "../sources/advisory_source_registry.dart";
import "advisory_source.dart";

class AdvisoryService {
  AdvisoryService(this._database, Dio dio, AdvisorySourceRegistry registry)
      : sources = [
          UsStateDeptAdvisorySource(dio, registry),
          UkFcdoAdvisorySource(dio, registry),
          CanadaGacAdvisorySource(dio, registry),
          FranceDiplomatieAdvisorySource(dio, registry),
          AustraliaDfatAdvisorySource(dio, registry),
          GermanyAaAdvisorySource(dio, registry),
        ];

  final AdvisoryDatabase _database;
  final List<AdvisorySource> sources;

  Future<List<AdvisoryData>> fetchAllForCountry(String countryCode) async {
    final fetched = <AdvisoryData>[];
    for (final source in sources) {
      try {
        final advisory = await source.fetch(countryCode);
        if (advisory != null) {
          await _database.upsertAdvisory(advisory);
          fetched.add(advisory);
        }
      } catch (_) {
        continue;
      }
    }
    return fetched;
  }

  Future<List<AdvisoryData>> fetchAllCountries() async {
    final countries = await _database.getAllCountries();
    final results = <AdvisoryData>[];
    for (final country in countries) {
      final code = country["country_code"]?.toString();
      if (code == null || code.isEmpty) continue;
      results.addAll(await fetchAllForCountry(code));
    }
    return results;
  }

  Future<List<AdvisoryData>> getAdvisoriesForCountry(String countryCode) {
    return _database.getAdvisoriesByCountry(countryCode);
  }

  Future<int> getConsolidatedLevel(String countryCode) async {
    final advisories = await _database.getAdvisoriesByCountry(countryCode);
    if (advisories.isEmpty) return 1;
    return advisories
        .map((advisory) => advisory.advisoryLevel)
        .reduce((left, right) => left > right ? left : right);
  }
}
