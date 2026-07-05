import "dart:convert";

import "package:flutter/services.dart" show rootBundle;

class AdvisorySourceRegistry {
  AdvisorySourceRegistry._();

  static final AdvisorySourceRegistry instance = AdvisorySourceRegistry._();

  Map<String, String>? _countryNames;

  Future<Map<String, String>> _loadCountryNames() async {
    if (_countryNames != null) return _countryNames!;
    final raw = await rootBundle.loadString("assets/countries.json");
    final decoded = jsonDecode(raw) as List<dynamic>;
    final map = <String, String>{};
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        final code = item["country_code"]?.toString().toUpperCase();
        final name = item["name"]?.toString().trim();
        if (code != null && code.isNotEmpty && name != null && name.isNotEmpty) {
          map[code] = name;
        }
      }
    }
    _countryNames = map;
    return map;
  }

  Future<String?> countryName(String countryCode) async {
    final map = await _loadCountryNames();
    return map[countryCode.toUpperCase()];
  }

  Future<String> slugForCountryCode(String countryCode) async {
    final name = await countryName(countryCode);
    if (name == null || name.isEmpty) return countryCode.toLowerCase();
    return slugify(name);
  }

  Future<Map<String, String>> sourceParameters(String countryCode) async {
    final name = await countryName(countryCode);
    final slug = name == null ? countryCode.toLowerCase() : slugify(name);
    return {
      "countryCode": countryCode.toUpperCase(),
      "countryName": name ?? countryCode.toUpperCase(),
      "stateDeptCountryCode": countryCode.toUpperCase(),
      "ukCountrySlug": slug,
      "canadaCountrySlug": slug,
      "franceCountrySlug": slug,
      "australiaCountrySlug": slug,
      "germanyCountrySlug": slug,
    };
  }

  String slugify(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r"[’']"), "")
        .replaceAll(RegExp(r"[^a-z0-9]+"), "-")
        .replaceAll(RegExp(r"-+"), "-")
        .replaceAll(RegExp(r"(^-|-$)"), "");
    return normalized;
  }
}
