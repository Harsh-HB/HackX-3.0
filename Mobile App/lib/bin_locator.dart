import 'package:flutter/material.dart';
import 'dart:math' as math;

class BinLocator extends StatefulWidget {
  const BinLocator({super.key});

  @override
  State<BinLocator> createState() => _BinLocatorState();
}

class _BinLocatorState extends State<BinLocator> {
  // Fake current location (Connaught Place, Delhi)
  double _myLat = 28.6315;
  double _myLng = 77.2167;

  // Hardcoded bins with coordinates
  final List<Map<String, dynamic>> _bins = [
    {'id': 'A-101', 'address': 'Sector 12, Park Ave', 'lat': 28.6129, 'lng': 77.2295, 'fill': 92.0},
    {'id': 'B-204', 'address': 'Main Street, Block B', 'lat': 28.6134, 'lng': 77.2100, 'fill': 41.0},
    {'id': 'C-330', 'address': 'City Mall, Gate 3', 'lat': 28.6200, 'lng': 77.2150, 'fill': 76.0},
    {'id': 'D-118', 'address': 'Metro Station North', 'lat': 28.6255, 'lng': 77.2301, 'fill': 15.0},
    {'id': 'E-509', 'address': 'Riverside Road', 'lat': 28.6011, 'lng': 77.2509, 'fill': 88.0},
  ];

  // Haversine distance in kilometers
  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180.0);

  List<Map<String, dynamic>> get _sorted {
    final list = _bins.map((b) {
      final d = _distanceKm(_myLat, _myLng, (b['lat'] as num).toDouble(), (b['lng'] as num).toDouble());
      return {...b, 'dist': d};
    }).toList();
    list.sort((a, b) => (a['dist'] as double).compareTo(b['dist'] as double));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin Locator'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Randomize My Location',
            onPressed: () {
              setState(() {
                // Small random shift to simulate movement
                _myLat += (math.Random().nextDouble() - 0.5) * 0.01;
                _myLng += (math.Random().nextDouble() - 0.5) * 0.01;
              });
            },
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, color: primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Current: ${_myLat.toStringAsFixed(5)}, ${_myLng.toStringAsFixed(5)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      // Reset to default coordinate
                      _myLat = 28.6315;
                      _myLng = 77.2167;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _sorted.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final d = _sorted[i];
                final dist = (d['dist'] as double);
                final fill = (d['fill'] as num).toDouble();

                Color bar = Colors.indigo;
                if (fill >= 80) {
                  bar = Colors.red.shade700;
                } else if (fill >= 60) {
                  bar = Colors.orange.shade700;
                }

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: bar.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.delete_outline, color: bar),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Bin ${d['id']}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            ),
                            Text('${dist.toStringAsFixed(2)} km',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(d['address'] as String, style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            value: (fill / 100).clamp(0.0, 1.0),
                            color: bar,
                            backgroundColor: bar.withOpacity(0.12),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Fill: ${fill.toStringAsFixed(0)}%'),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // In a real app this would open a maps intent
                               // ScaffoldMessenger.of(context).showSnackBar(
                                 // SnackBar(content: Text('Navigate to ${d['id']} (simulated)')),
                               // );
                              },
                              icon: const Icon(Icons.navigation),
                              label: const Text('Navigate'),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Reported issue for ${d['id']}')),
                                );
                              },
                              icon: const Icon(Icons.report_gmailerrorred_outlined),
                              label: const Text('Report Issue'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
