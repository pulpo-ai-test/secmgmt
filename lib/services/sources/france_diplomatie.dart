import "package:dio/dio.dart";

import "../../models/advisory.dart";
import "../../sources/advisory_source_registry.dart";
import "../advisory_source.dart";
import "advisory_source_helpers.dart";

class FranceDiplomatieAdvisorySource implements AdvisorySource {
  FranceDiplomatieAdvisorySource(this._dio, this._registry);

  final Dio _dio;
  final AdvisorySourceRegistry _registry;

  @override
  String get sourceId => AdvisorySourceId.franceDiplo.value;

  @override
  Future<AdvisoryData?> fetch(String countryCode) async {
    try {
      final params = await _registry.sourceParameters(countryCode);
      final slug = params["franceCountrySlug"] ?? countryCode.toLowerCase();
      final candidates = <String>[
        "https://www.diplomatie.gouv.fr/en/country-files/travel-advice-for-$slug/",
        "https://www.diplomatie.gouv.fr/fr/conseils-aux-voyageurs/conseils-par-pays/$slug/",
      ];

      for (final url in candidates) {
        try {
          final response = await safeGet(_dio, url);
          final text = stripTags(response.data?.toString() ?? "");
          if (text.isEmpty) continue;
          return buildAdvisory(
            countryCode: countryCode,
            source: AdvisorySourceId.franceDiplo,
            advisoryLevel: parseAdvisoryLevel(text),
            fullText: text,
            sourceUrl: url,
            lastUpdated: DateTime.now().toUtc(),
          );
        } catch (_) {
          continue;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
