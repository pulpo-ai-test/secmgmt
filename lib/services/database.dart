import 'package:sembast/sembast.dart';
import 'db_factory_web.dart'
    if (dart.library.io) 'db_factory_io.dart';

class AppDatabase {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabaseFactory().openDatabase('secmgmt');
    return _db!;
  }

  StoreRef<String, Map<String, dynamic>> get _countryStore =>
      stringMapStoreFactory.store('countries');

  Future<void> seedCountries(List<Map<String, dynamic>> countries) async {
    final db = await database;
    await _countryStore.delete(db);
    for (final c in countries) {
      await _countryStore.record(c['country_code'] as String).put(db, c);
    }
  }

  Future<List<Map<String, dynamic>>> getAllCountries() async {
    final db = await database;
    final records = await _countryStore.find(db);
    return records.map((r) => r.value).toList();
  }

  Future<Map<String, dynamic>?> getCountryByCode(String code) async {
    final db = await database;
    return await _countryStore.record(code).get(db);
  }

  Future<int> countryCount() async {
    return (await getAllCountries()).length;
  }

  StoreRef<String, Map<String, dynamic>> get _advisoryStore =>
      stringMapStoreFactory.store('advisories');

  Future<void> upsertAdvisory(Map<String, dynamic> advisory) async {
    final db = await database;
    final key = '${advisory['country_code']}_${advisory['source']}';
    await _advisoryStore.record(key).put(db, advisory);
  }

  Future<List<Map<String, dynamic>>> getAdvisoriesForCountry(String countryCode) async {
    final db = await database;
    final records = await _advisoryStore.find(db,
        finder: Finder(filter: Filter.equals('country_code', countryCode)));
    return records.map((r) => r.value).toList();
  }

  Future<List<Map<String, dynamic>>> getAllAdvisories() async {
    final db = await database;
    final records = await _advisoryStore.find(db);
    return records.map((r) => r.value).toList();
  }
}
