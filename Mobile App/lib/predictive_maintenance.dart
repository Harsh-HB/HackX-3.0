import 'package:flutter/material.dart';

class PredictiveMaintenance extends StatelessWidget {
  const PredictiveMaintenance({super.key});

  List<Map<String, dynamic>> get _bins => [
    {
      'id': 'A-101',
      'status': 'active',
      'fillLevel': 92.0,
      'history': _genHistory([60, 72, 84, 92], hoursStep: 2),
    },
    {
      'id': 'E-509',
      'status': 'active',
      'fillLevel': 88.0,
      'history': _genHistory([40, 55, 70, 88], hoursStep: 3),
    },
    {
      'id': 'C-330',
      'status': 'active',
      'fillLevel': 76.0,
      'history': _genHistory([30, 48, 63, 76], hoursStep: 2),
    },
    {
      'id': 'D-118',
      'status': 'maintenance',
      'fillLevel': 15.0,
      'history': _genHistory([10, 11, 13, 15], hoursStep: 4),
    },
  ];

  static List<Map<String, dynamic>> _genHistory(List<double> levels, {int hoursStep = 2}) {
    final now = DateTime.now();
    final start = now.subtract(Duration(hours: hoursStep * (levels.length - 1)));
    return List.generate(levels.length, (i) {
      return {'level': levels[i], 'ts': start.add(Duration(hours: hoursStep * i))};
    });
  }

  double _estimateHours(Map<String, dynamic> bin) {
    final current = (bin['fillLevel'] as num).toDouble();
    final history = (bin['history'] as List).cast<Map<String, dynamic>>();
    if (history.length < 2) {
      final rate = current >= 70 ? 10.0 : 5.0; // % per hour
      return (100 - current) / rate;
    }
    double sumSlope = 0;
    int segments = 0;
    for (int i = 1; i < history.length; i++) {
      final prev = history[i - 1];
      final cur = history[i];
      final lvPrev = (prev['level'] as num).toDouble();
      final lvCur = (cur['level'] as num).toDouble();
      final tsPrev = prev['ts'] as DateTime;
      final tsCur = cur['ts'] as DateTime;
      final hours = tsCur.difference(tsPrev).inMinutes / 60.0;
      if (hours > 0) {
        sumSlope += (lvCur - lvPrev) / hours;
        segments++;
      }
    }
    final slope = segments == 0 ? 5.0 : (sumSlope / segments).clamp(0.5, 50.0);
    return (100 - current) / slope;
  }

  @override
  Widget build(BuildContext context) {
    final items = _bins
        .map((b) => {
      'id': b['id'],
      'status': b['status'],
      'fillLevel': b['fillLevel'],
      'etaHrs': _estimateHours(b),
    })
        .toList()
      ..sort((a, b) => (a['etaHrs'] as double).compareTo(b['etaHrs'] as double));

    const primary = Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predictive Maintenance'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final id = items[i]['id'] as String;
          final status = items[i]['status'] as String;
          final level = (items[i]['fillLevel'] as num).toDouble();
          final etaHrs = items[i]['etaHrs'] as double;

          Color line = Colors.indigo;
          if (etaHrs < 2) {
            line = Colors.red.shade700;
          } else if (etaHrs < 6) {
            line = Colors.orange.shade700;
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: line.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.auto_graph, color: line),
                      ),
                      const SizedBox(width: 12),
                      // Title that can shrink
                      Expanded(
                        child: Text(
                          'Bin $id',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Constrained chip that won’t force overflow
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: line.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${etaHrs.isFinite ? etaHrs.toStringAsFixed(1) : '∞'} hrs',
                              style: TextStyle(color: line, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Status: ${status.toUpperCase()}', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: (level / 100).clamp(0.0, 1.0),
                      color: line,
                      backgroundColor: line.withOpacity(0.12),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Current fill: ${level.toStringAsFixed(0)}%'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // In hardcoded mode, this is a no-op or a snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Maintenance scheduled for $id'),
                              backgroundColor: Colors.teal.shade700,
                            ),
                          );
                        },
                        icon: const Icon(Icons.build_outlined),
                        label: const Text('Schedule Maintenance'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Marked $id emptied'),
                              backgroundColor: const Color(0xFF2E7D32),
                            ),
                          );
                        },
                        icon: const Icon(Icons.done_all),
                        label: const Text('Mark Emptied'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
