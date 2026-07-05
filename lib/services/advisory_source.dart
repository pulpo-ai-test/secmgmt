import "../models/advisory.dart";

abstract class AdvisorySource {
  String get sourceId;

  Future<AdvisoryData?> fetch(String countryCode);
}
