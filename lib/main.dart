import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "services/country_service.dart";
import "package:secmgmt/services/database.dart";
import "screens/map_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-seed database before app starts
  final db = AppDatabase();
  final service = CountryService(db);
  await service.initializeAndSeed();

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
