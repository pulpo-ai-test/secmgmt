import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "../providers/country_provider.dart";

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("SecMgmt"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: () {},
            tooltip: "Layers",
          ),
        ],
      ),
      body: countriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text("Error: $error"),
        ),
        data: (countries) => FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(0, 0),
            initialZoom: 3,
            maxZoom: 18,
            minZoom: 2,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.example.secmgmt",
            ),
            if (countries.isNotEmpty)
              MarkerLayer(
                markers: countries.map((c) => Marker(
                  point: LatLng(c["lat"] as double, c["lng"] as double),
                  width: 100,
                  height: 30,
                  child: Text(
                    c["name"] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
