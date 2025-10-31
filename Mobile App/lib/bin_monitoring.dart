import 'package:flutter/material.dart';
import 'dart:math' as math;

class BinMonitoring extends StatefulWidget {
  const BinMonitoring({super.key});

  @override
  State<BinMonitoring> createState() => _BinMonitoringState();
}

class _BinMonitoringState extends State<BinMonitoring> {
  // Hardcoded bins list
  final List<Map<String, dynamic>> _bins = [
    {
      'id': 'A-101',
      'address': 'Sector 12, Park Ave',
      'lat': 28.6129,
      'lng': 77.2295,
      'fillLevel': 92.0,
      'status': 'full',
      'lastEmptied': DateTime.now().subtract(const Duration(hours: 20)),
    },
    {
      'id': 'B-204',
      'address': 'Main Street, Block B',
      'lat': 28.6134,
      'lng': 77.2100,
      'fillLevel': 41.0,
      'status': 'active',
      'lastEmptied': DateTime.now().subtract(const Duration(hours: 6)),
    },
    {
      'id': 'C-330',
      'address': 'City Mall, Gate 3',
      'lat': 28.6200,
      'lng': 77.2150,
      'fillLevel': 76.0,
      'status': 'active',
      'lastEmptied': DateTime.now().subtract(const Duration(hours: 10)),
    },
    {
      'id': 'D-118',
      'address': 'Metro Station North',
      'lat': 28.6255,
      'lng': 77.2301,
      'fillLevel': 15.0,
      'status': 'maintenance',
      'lastEmptied': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    },
    {
      'id': 'E-509',
      'address': 'Riverside Road',
      'lat': 28.6011,
      'lng': 77.2509,
      'fillLevel': 88.0,
      'status': 'full',
      'lastEmptied': DateTime.now().subtract(const Duration(hours: 16)),
    },
  ];

  String _statusFilter = 'all'; // all | active | maintenance | full
  RangeValues _fillRange = const RangeValues(0, 100);

  List<Map<String, dynamic>> get _filtered {
    final lo = _fillRange.start;
    final hi = _fillRange.end;
    final out = _bins.where((b) {
      final okStatus = _statusFilter == 'all' || b['status'] == _statusFilter;
      final level = (b['fillLevel'] as num).toDouble();
      final okLevel = level >= lo && level <= hi;
      return okStatus && okLevel;
    }).toList();

    // Sort by fill level descending
    out.sort((a, b) => (b['fillLevel'] as double).compareTo(a['fillLevel'] as double));
    return out;
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'full':
        return Colors.red.shade600;
      case 'maintenance':
        return Colors.amber.shade700;
      case 'active':
        return const Color(0xFF2E7D32);
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin Monitoring'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _Filters(
            status: _statusFilter,
            range: _fillRange,
            onStatus: (s) => setState(() => _statusFilter = s),
            onRange: (r) => setState(() => _fillRange = r),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final d = _filtered[i];
                final id = d['id'] as String;
                final level = (d['fillLevel'] as num).toDouble();
                final status = d['status'] as String;
                final address = d['address'] as String;
                final lastEmptied = d['lastEmptied'] as DateTime;

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
                                color: _statusColor(status).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.delete_outline, color: _statusColor(status)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Bin $id',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _statusColor(status).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  color: _statusColor(status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(address, style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            value: (level / 100).clamp(0.0, 1.0),
                            color: _statusColor(status),
                            backgroundColor: _statusColor(status).withOpacity(0.12),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fill: ${level.toStringAsFixed(0)}%'),
                            Text('Last emptied: ${_fmt(lastEmptied)}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => setState(() {
                                d['status'] = 'maintenance';
                              }),
                              icon: const Icon(Icons.build_outlined),
                              label: const Text('Maintenance'),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => setState(() {
                                d['status'] = 'active';
                                d['lastEmptied'] = DateTime.now();
                                d['fillLevel'] = math.max(0.0, level - 50.0);
                              }),
                              icon: const Icon(Icons.done_all),
                              label: const Text('Emptied'),
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

  String _fmt(DateTime dt) {
    final d = dt.toLocal();
    return '${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}';
    // Keep it simple; no intl dependency needed.
  }

  String _two(int v) => v < 10 ? '0$v' : '$v';
}

class _Filters extends StatelessWidget {
  final String status;
  final RangeValues range;
  final ValueChanged<String> onStatus;
  final ValueChanged<RangeValues> onRange;

  const _Filters({
    required this.status,
    required this.range,
    required this.onStatus,
    required this.onRange,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);
    return Material(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _chip('all', status == 'all', primary, onStatus),
                _chip('active', status == 'active', primary, onStatus),
                _chip('maintenance', status == 'maintenance', primary, onStatus),
                _chip('full', status == 'full', primary, onStatus),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Fill level'),
                const SizedBox(width: 12),
                Expanded(
                  child: RangeSlider(
                    values: range,
                    min: 0,
                    max: 100,
                    labels: RangeLabels(
                      '${range.start.toStringAsFixed(0)}%',
                      '${range.end.toStringAsFixed(0)}%',
                    ),
                    activeColor: primary,
                    onChanged: onRange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, Color color, ValueChanged<String> onTap) {
    return ChoiceChip(
      label: Text(label.toUpperCase()),
      selected: selected,
      onSelected: (_) => onTap(label),
      selectedColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: selected ? color : Colors.black87, fontWeight: FontWeight.w700),
      side: BorderSide(color: selected ? color : Colors.black26),
    );
  }
}
