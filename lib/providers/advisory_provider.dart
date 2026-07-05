import "package:flutter_riverpod/flutter_riverpod.dart";
import "../services/database.dart";
import "../services/advisory_service.dart";

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final advisoryServiceProvider = Provider<AdvisoryService>((ref) {
  return AdvisoryService(ref.read(databaseProvider));
});

final advisoryLevelsProvider = FutureProvider<Map<String, int>>((ref) async {
  final service = ref.read(advisoryServiceProvider);
  return service.loadAdvisories();
});
