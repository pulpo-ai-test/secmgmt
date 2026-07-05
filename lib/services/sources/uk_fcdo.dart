import "dart:convert";

import "package:dio/dio.dart";

import "../../models/advisory.dart";
import "../../sources/advisory_source_registry.dart";
import "../advisory_source.dart";
import "advisory_source_helpers.dart";

class UkFcdoAdvisorySource implements AdvisorySource {
  UkFcdoAdvisorySource(this._dio, this._registry);

  final Dio _dio;
  final AdvisorySourceRegistry _registry;

  @override
  String get sourceId => AdvisorySourceId.ukFco.value;

  @override
  Future<AdvisoryData?> fetch(String countryCode) async {
    try {
      final params = await _registry.sourceParameters(countryCode);
      final slug = params["ukCountrySlug"] ?? countryCode.toLowerCase();
      final url = "https://www.gov.uk/api/content/foreign-travel-advice/$slug";
      final response = await safeGet(_dio, url);
      final body = response.data?.toString() ?? "";
      if (body.trim().isEmpty) return null;
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return null;

      final text = stripTags([
        decoded["title"]?.toString(),
        decoded["description"]?.toString(),
        decoded["details"] is Map<String, dynamic>
            ? (decoded["details"] as Map<String, dynamic>)["body"]?.toString()
            : null,
        decoded["details"] is Map<String, dynamic>
            ? (decoded["details"] as Map<String, dynamic>)["summary"]?.toString()
            : null,
      ].whereType<String>().join(" "));

      if (text.isEmpty) return null;

      return buildAdvisory(
        countryCode: countryCode,
        source: AdvisorySourceId.ukFco,
        advisoryLevel: _levelFromText(text),
        fullText: text,
        sourceUrl: firstNonEmpty([
          decoded["base_path"]?.toString(),
          decoded["public_updated_at"]?.toString(),
          url,
        ], fallback: url),
        lastUpdated: parseDateTime(decoded["updated_at"]?.toString()) ?? DateTime.now().toUtc(),
      );
    } catch (_) {
      return null;
    }
  }

  int _levelFromText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains("avoid all travel") || lower.contains("do not travel")) {
      return 4;
    }
    if (lower.contains("advise against all but essential travel") ||
        lower.contains("reconsider travel")) {
      return 3;
    }
    if (lower.contains("exercise a high degree of caution") ||
        lower.contains("exercise caution")) {
      return 2;
    }
    return parseAdvisoryLevel(text);
  }
}
