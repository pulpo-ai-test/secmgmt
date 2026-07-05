import "package:dio/dio.dart";

import "../../models/advisory.dart";
import "../../sources/advisory_source_registry.dart";
import "../advisory_source.dart";
import "advisory_source_helpers.dart";

class CanadaGacAdvisorySource implements AdvisorySource {
  CanadaGacAdvisorySource(this._dio, this._registry);

  final Dio _dio;
  final AdvisorySourceRegistry _registry;

  @override
  String get sourceId => AdvisorySourceId.canadaGac.value;

  @override
  Future<AdvisoryData?> fetch(String countryCode) async {
    try {
      final params = await _registry.sourceParameters(countryCode);
      final slug = params["canadaCountrySlug"] ?? countryCode.toLowerCase();
      final candidates = <String>[
        "https://travel.gc.ca/travelling/advisories/$slug",
        "https://travel.gc.ca/travelling/advisories/$slug-0",
      ];

      for (final url in candidates) {
        try {
          final response = await safeGet(_dio, url);
          final text = stripTags(response.data?.toString() ?? "");
          if (text.isEmpty) continue;
          final level = _levelFromText(text);
          if (level == 1 && !text.toLowerCase().contains("travel")) {
            continue;
          }
          return buildAdvisory(
            countryCode: countryCode,
            source: AdvisorySourceId.canadaGac,
            advisoryLevel: level,
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
    if (lower.contains("avoid all travel")) return 4;
    if (lower.contains("avoid non-essential travel") || lower.contains("reconsider your need to travel")) {
      return 3;
    }
    if (lower.contains("exercise a high degree of caution") || lower.contains("take normal security precautions")) {
      return 2;
    }
    return parseAdvisoryLevel(text);
  }
}
