class Country {
  final String countryCode;
  final String name;
  final String region;
  final double lat;
  final double lng;

  Country({
    required this.countryCode,
    required this.name,
    required this.region,
    required this.lat,
    required this.lng,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      countryCode: map["country_code"] as String,
      name: map["name"] as String,
      region: map["region"] as String,
      lat: (map["lat"] as num).toDouble(),
      lng: (map["lng"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "country_code": countryCode,
      "name": name,
      "region": region,
      "lat": lat,
      "lng": lng,
    };
  }
}
