import "dart:convert";

enum AdvisorySourceId {
  stateDept("state_dept"),
  ukFco("uk_fco"),
  canadaGac("canada_gac"),
  franceDiplo("france_diplo"),
  australiaDfat("australia_dfat"),
  germanyAa("germany_aa");

  const AdvisorySourceId(this.value);

  final String value;

  static AdvisorySourceId? fromValue(String value) {
    for (final source in AdvisorySourceId.values) {
      if (source.value == value) return source;
    }
    return null;
  }
}

class AdvisoryData {
  final String countryCode;
  final AdvisorySourceId source;
  final int advisoryLevel;
  final List<String> riskFactors;
  final String fullText;
  final DateTime lastUpdated;
  final String sourceUrl;

  const AdvisoryData({
    required this.countryCode,
    required this.source,
    required this.advisoryLevel,
    required this.riskFactors,
    required this.fullText,
    required this.lastUpdated,
    required this.sourceUrl,
  });

  factory AdvisoryData.fromMap(Map<String, dynamic> map) {
    final rawRiskFactors = map["risk_factors"];
    List<String> riskFactors;
    if (rawRiskFactors is String && rawRiskFactors.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawRiskFactors);
        riskFactors = decoded is List
            ? decoded.map((item) => item.toString()).toList()
            : <String>[];
      } catch (_) {
        riskFactors = <String>[];
      }
    } else if (rawRiskFactors is List) {
      riskFactors = rawRiskFactors.map((item) => item.toString()).toList();
    } else {
      riskFactors = <String>[];
    }

    final rawSource = map["source"]?.toString() ?? AdvisorySourceId.stateDept.value;
    final source = AdvisorySourceId.fromValue(rawSource) ?? AdvisorySourceId.stateDept;
    final rawLastUpdated = map["last_updated"];
    final lastUpdated = rawLastUpdated is DateTime
        ? rawLastUpdated
        : DateTime.tryParse(rawLastUpdated?.toString() ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);

    return AdvisoryData(
      countryCode: map["country_code"]?.toString().toUpperCase() ?? "",
      source: source,
      advisoryLevel: (map["advisory_level"] as num?)?.toInt() ?? 1,
      riskFactors: riskFactors,
      fullText: map["full_text"]?.toString() ?? "",
      lastUpdated: lastUpdated,
      sourceUrl: map["source_url"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "country_code": countryCode.toUpperCase(),
      "source": source.value,
      "advisory_level": advisoryLevel,
      "risk_factors": jsonEncode(riskFactors),
      "full_text": fullText,
      "last_updated": lastUpdated.toIso8601String(),
      "source_url": sourceUrl,
    };
  }

  AdvisoryData copyWith({
    String? countryCode,
    AdvisorySourceId? source,
    int? advisoryLevel,
    List<String>? riskFactors,
    String? fullText,
    DateTime? lastUpdated,
    String? sourceUrl,
  }) {
    return AdvisoryData(
      countryCode: countryCode ?? this.countryCode,
      source: source ?? this.source,
      advisoryLevel: advisoryLevel ?? this.advisoryLevel,
      riskFactors: riskFactors ?? this.riskFactors,
      fullText: fullText ?? this.fullText,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      sourceUrl: sourceUrl ?? this.sourceUrl,
    );
  }
}
