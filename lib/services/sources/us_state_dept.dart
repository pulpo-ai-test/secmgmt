import "dart:convert";

import "package:dio/dio.dart";

import "../../models/advisory.dart";
import "../../sources/advisory_source_registry.dart";
import "../advisory_source.dart";
import "advisory_source_helpers.dart";

class UsStateDeptAdvisorySource implements AdvisorySource {
  UsStateDeptAdvisorySource(this._dio, this._registry);

  final Dio _dio;
  final AdvisorySourceRegistry _registry;

  @override
  String get sourceId => AdvisorySourceId.stateDept.value;

  @override
  Future<AdvisoryData?> fetch(String countryCode) async {
    try {
      final params = await _registry.sourceParameters(countryCode);
      final apiUrl =
          "https://cadataapi.state.gov/api/CountryTravelInformation/${params["stateDeptCountryCode"]}";
      final apiResponse = await safeGet(_dio, apiUrl);
      final advisory = _parseApiResponse(
        apiResponse.data?.toString() ?? "",
        countryCode,
        apiUrl,
      );
      if (advisory != null) return advisory;

      final rssUrl = "https://travel.state.gov/_res/rss/TravelAdvisories.xml";
      final rssResponse = await safeGet(_dio, rssUrl);
      return _parseRss(
        rssResponse.data?.toString() ?? "",
        countryCode,
        params["countryName"] ?? countryCode,
        rssUrl,
      );
    } catch (_) {
      return null;
    }
  }

  AdvisoryData? _parseApiResponse(String body, String countryCode, String sourceUrl) {
    if (body.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final text = _extractText(decoded);
        if (text.isEmpty) return null;
        final level = _extractLevel(decoded, text);
        return buildAdvisory(
          countryCode: countryCode,
          source: AdvisorySourceId.stateDept,
          advisoryLevel: level,
          fullText: text,
          sourceUrl: _extractSourceUrl(decoded, sourceUrl),
          lastUpdated: parseDateTime(
                decoded["lastUpdated"]?.toString() ??
                    decoded["updated"]?.toString() ??
                    decoded["modified"]?.toString(),
              ) ??
              DateTime.now().toUtc(),
        );
      }
    } catch (_) {
      // Fall through to RSS parsing.
    }
    return null;
  }

  AdvisoryData? _parseRss(
    String body,
    String countryCode,
    String countryName,
    String sourceUrl,
  ) {
    if (body.trim().isEmpty) return null;
    final items = RegExp(r"<item>([\s\S]*?)</item>", caseSensitive: false).allMatches(body);
    for (final item in items) {
      final chunk = item.group(1) ?? "";
      final title = _tagValue(chunk, "title");
      if (title.isEmpty) continue;
      final matchesCountry =
          title.toLowerCase().contains(countryName.toLowerCase()) ||
          title.toLowerCase().contains(countryCode.toLowerCase());
      if (!matchesCountry) continue;
      final description = _tagValue(chunk, "description");
      final text = stripTags("$title $description");
      return buildAdvisory(
        countryCode: countryCode,
        source: AdvisorySourceId.stateDept,
        advisoryLevel: parseAdvisoryLevel(text),
        fullText: text,
        sourceUrl: _tagValue(chunk, "link").isNotEmpty ? _tagValue(chunk, "link") : sourceUrl,
        lastUpdated: parseDateTime(_tagValue(chunk, "pubDate")) ?? DateTime.now().toUtc(),
      );
    }
    return null;
  }

  String _extractText(Map<String, dynamic> data) {
    final pieces = <String>[
      data["title"]?.toString() ?? "",
      data["summary"]?.toString() ?? "",
      data["description"]?.toString() ?? "",
      data["body"]?.toString() ?? "",
      data["content"]?.toString() ?? "",
    ];
    final details = data["details"];
    if (details is Map<String, dynamic>) {
      pieces.addAll([
        details["body"]?.toString() ?? "",
        details["summary"]?.toString() ?? "",
        details["description"]?.toString() ?? "",
      ]);
    }
    return stripTags(pieces.whereType<String>().where((value) => value.trim().isNotEmpty).join(" "));
  }

  int _extractLevel(Map<String, dynamic> data, String text) {
    final candidates = <String>[
      data["level"]?.toString() ?? "",
      data["advisoryLevel"]?.toString() ?? "",
      data["travel_advisory_level"]?.toString() ?? "",
      text,
    ];
    for (final candidate in candidates) {
      final match = RegExp(r"level\s*([1-4])", caseSensitive: false).firstMatch(candidate);
      if (match != null) {
        return int.tryParse(match.group(1) ?? "") ?? parseAdvisoryLevel(text);
      }
    }
    return parseAdvisoryLevel(text);
  }

  String _extractSourceUrl(Map<String, dynamic> data, String fallback) {
    return firstNonEmpty([
      data["url"]?.toString(),
      data["sourceUrl"]?.toString(),
      data["link"]?.toString(),
      fallback,
    ], fallback: fallback);
  }

  String _tagValue(String input, String tag) {
    final match = RegExp(r"<$tag[^>]*>([\s\S]*?)</$tag>", caseSensitive: false).firstMatch(input);
    return stripTags(match?.group(1) ?? "");
  }
}
