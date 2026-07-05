import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "services/database.dart";
import "services/country_service.dart";
import "screens/map_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final db = AppDatabase();
    final service = CountryService(db);
    await service.initializeAndSeed();
  } catch (e) {
    debugPrint("Database init skipped: $e");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SecMgmt",
      theme: ThemeData.dark(),
      home: const MapScreen(),
    );
  }
}
