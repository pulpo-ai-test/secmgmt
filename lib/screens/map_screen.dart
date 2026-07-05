import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "../providers/advisory_provider.dart";
import "../providers/country_provider.dart";

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countries = ref.watch(countriesProvider).asData?.value ?? [];
    final advisories = ref.watch(advisoryLevelsProvider).asData?.value ?? {};

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
      body: Stack(
        children: [
          FlutterMap(
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
                  markers: countries.map((c) => _countryMarker(context, c, advisories)).toList(),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.all(12),
              child: _Legend(),
            ),
          ),
        ],
      ),
    );
  }

  Marker _countryMarker(
    BuildContext context,
    Map<String, dynamic> country,
    Map<String, int> advisoryLevels,
  ) {
    final code = country["country_code"]?.toString().toUpperCase() ?? "";
    final name = country["name"]?.toString() ?? code;
    final level = advisoryLevels[code] ?? 0;
    final color = _levelColor(level);

    return Marker(
      point: LatLng(
        (country["lat"] as num).toDouble(),
        (country["lng"] as num).toDouble(),
      ),
      width: 160,
      height: 32,
      child: GestureDetector(
        onTap: () {
          // advisory level dot color indicates status
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" (): ")),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 112,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 3)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _levelColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF40C057);
      case 2:
        return const Color(0xFFFCC419);
      case 3:
        return const Color(0xFFFF922B);
      case 4:
        return const Color(0xFFE03131);
      default:
        return Colors.grey;
    }
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LegendItem(label: "L1", color: const Color(0xFF40C057)),
            const SizedBox(width: 12),
            _LegendItem(label: "L2", color: const Color(0xFFFCC419)),
            const SizedBox(width: 12),
            _LegendItem(label: "L3", color: const Color(0xFFFF922B)),
            const SizedBox(width: 12),
            _LegendItem(label: "L4", color: const Color(0xFFE03131)),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
