import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/advisory.dart";
import "../services/advisory_database.dart";
import "../services/advisory_service.dart";
import "../sources/advisory_source_registry.dart";

final advisoryDatabaseProvider = Provider<AdvisoryDatabase>((ref) {
  return AdvisoryDatabase();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );
});

final advisorySourceRegistryProvider = Provider<AdvisorySourceRegistry>((ref) {
  return AdvisorySourceRegistry.instance;
});

final advisoryServiceProvider = Provider<AdvisoryService>((ref) {
  return AdvisoryService(
    ref.read(advisoryDatabaseProvider),
    ref.read(dioProvider),
    ref.read(advisorySourceRegistryProvider),
  );
});

final advisoryForCountryProvider =
    FutureProvider.family<List<AdvisoryData>, String>((ref, countryCode) async {
  return ref.read(advisoryServiceProvider).getAdvisoriesForCountry(countryCode);
});

final consolidatedAdvisoryLevelProvider = FutureProvider.family<int, String>((ref, countryCode) async {
  return ref.read(advisoryServiceProvider).getConsolidatedLevel(countryCode);
});
