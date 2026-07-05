import "package:dio/dio.dart";

import "../../models/advisory.dart";
import "../../sources/advisory_source_registry.dart";
import "../advisory_source.dart";
import "advisory_source_helpers.dart";

class AustraliaDfatAdvisorySource implements AdvisorySource {
  AustraliaDfatAdvisorySource(this._dio, this._registry);

  final Dio _dio;
  final AdvisorySourceRegistry _registry;

  @override
  String get sourceId => AdvisorySourceId.australiaDfat.value;

  @override
  Future<AdvisoryData?> fetch(String countryCode) async {
    try {
      final params = await _registry.sourceParameters(countryCode);
      final slug = params["australiaCountrySlug"] ?? countryCode.toLowerCase();
      final candidates = <String>[
        "https://www.smartraveller.gov.au/destinations/$slug",
        "https://www.smartraveller.gov.au/destinations/${params["countryCode"]}",
      ];

      for (final url in candidates) {
        try {
          final response = await safeGet(_dio, url);
          final text = stripTags(response.data?.toString() ?? "");
          if (text.isEmpty) continue;
          return buildAdvisory(
            countryCode: countryCode,
            source: AdvisorySourceId.australiaDfat,
            advisoryLevel: _levelFromText(text),
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

  int _levelFromText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains("do not travel")) return 4;
    if (lower.contains("reconsider your need to travel")) return 3;
    if (lower.contains("exercise a high degree of caution")) return 2;
    return parseAdvisoryLevel(text);
  }
}
