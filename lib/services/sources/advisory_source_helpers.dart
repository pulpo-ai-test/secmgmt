import "package:dio/dio.dart";

import "../../models/advisory.dart";

List<String> extractRiskFactors(String text) {
  final lower = text.toLowerCase();
  final factors = <String>[];

  void addIfPresent(String needle, String label) {
    if (lower.contains(needle) && !factors.contains(label)) {
      factors.add(label);
    }
  }

  addIfPresent("crime", "crime");
  addIfPresent("terror", "terrorism");
  addIfPresent("kidnap", "kidnapping");
  addIfPresent("civil unrest", "civil unrest");
  addIfPresent("protest", "civil unrest");
  addIfPresent("health", "health");
  addIfPresent("medical", "health");
  addIfPresent("war", "armed conflict");
  addIfPresent("conflict", "armed conflict");
  addIfPresent("earthquake", "natural disasters");
  addIfPresent("flood", "natural disasters");

  return factors;
}

int parseAdvisoryLevel(String text, {int fallback = 1}) {
  final match = RegExp(r"level\s*([1-4])", caseSensitive: false).firstMatch(text);
  if (match != null) {
    return int.tryParse(match.group(1) ?? "") ?? fallback;
  }

  final lower = text.toLowerCase();
  if (lower.contains("do not travel") || lower.contains("avoid all travel")) {
    return 4;
  }
  if (lower.contains("reconsider travel") || lower.contains("avoid non-essential travel")) {
    return 3;
  }
  if (lower.contains("exercise a high degree of caution") || lower.contains("high degree of caution")) {
    return 2;
  }
  return fallback;
}

String stripTags(String input) {
  return input
      .replaceAll(RegExp(r"<script[\s\S]*?</script>", caseSensitive: false), " ")
      .replaceAll(RegExp(r"<style[\s\S]*?</style>", caseSensitive: false), " ")
      .replaceAll(RegExp(r"<[^>]+>"), " ")
      .replaceAll(RegExp(r"&nbsp;"), " ")
      .replaceAll(RegExp(r"&amp;"), "&")
      .replaceAll(RegExp(r"\s+"), " ")
      .trim();
}

String firstNonEmpty(Iterable<String?> values, {String fallback = ""}) {
  for (final value in values) {
    if (value != null) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
  }
  return fallback;
}

DateTime? parseDateTime(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return DateTime.tryParse(value.trim());
}

Future<Response<dynamic>> safeGet(Dio dio, String url) {
  return dio.get<dynamic>(
    url,
    options: Options(
      responseType: ResponseType.plain,
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );
}

AdvisoryData buildAdvisory({
  required String countryCode,
  required AdvisorySourceId source,
  required int advisoryLevel,
  required String fullText,
  required String sourceUrl,
  DateTime? lastUpdated,
  List<String>? riskFactors,
}) {
  return AdvisoryData(
    countryCode: countryCode.toUpperCase(),
    source: source,
    advisoryLevel: advisoryLevel.clamp(1, 4).toInt(),
    riskFactors: riskFactors ?? extractRiskFactors(fullText),
    fullText: fullText.trim(),
    lastUpdated: lastUpdated ?? DateTime.now().toUtc(),
    sourceUrl: sourceUrl,
  );
}
