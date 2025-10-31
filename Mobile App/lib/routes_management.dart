import 'package:flutter/material.dart';

class RoutesManagement extends StatefulWidget {
  const RoutesManagement({super.key});

  @override
  State<RoutesManagement> createState() => _RoutesManagementState();
}

class _RoutesManagementState extends State<RoutesManagement> {
  final List<Map<String, dynamic>> _routes = [
    {
      'id': 'R-01',
      'routeName': 'Central Loop',
      'driverId': 'DRV-1001',
      'assignedBins': ['A-101', 'B-204', 'C-330'],
      'status': 'scheduled', // scheduled | active | completed
      'startTime': null,
      'endTime': null,
      'createdAt': DateTime.now().subtract(const Duration(hours: 4)),
    },
    {
      'id': 'R-02',
      'routeName': 'Riverside Sweep',
      'driverId': 'DRV-1003',
      'assignedBins': ['E-509'],
      'status': 'active',
      'startTime': DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      'endTime': null,
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': 'R-03',
      'routeName': 'Metro North',
      'driverId': 'DRV-1010',
      'assignedBins': ['D-118'],
      'status': 'completed',
      'startTime': DateTime.now().subtract(const Duration(hours: 6)),
      'endTime': DateTime.now().subtract(const Duration(hours: 3, minutes: 10)),
      'createdAt': DateTime.now().subtract(const Duration(hours: 7)),
    },
  ];

  Future<void> _createRouteDialog() async {
    final name = TextEditingController();
    final driver = TextEditingController();
    final binsText = TextEditingController();
    bool busy = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setD) => AlertDialog(
          title: const Text('Create New Route'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Route name')),
                const SizedBox(height: 8),
                TextField(controller: driver, decoration: const InputDecoration(labelText: 'Driver ID/Name')),
                const SizedBox(height: 8),
                TextField(
                  controller: binsText,
                  decoration: const InputDecoration(
                    labelText: 'Bin IDs (comma separated)',
                    helperText: 'Example: A-101,B-204,C-330',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: busy
                  ? null
                  : () {
                if (name.text.trim().isEmpty) return;
                final bins = binsText.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                setD(() => busy = true);
                setState(() {
                  _routes.insert(0, {
                    'id': 'R-${(_routes.length + 1).toString().padLeft(2, '0')}',
                    'routeName': name.text.trim(),
                    'driverId': driver.text.trim().isEmpty ? 'Unassigned' : driver.text.trim(),
                    'assignedBins': bins,
                    'status': 'scheduled',
                    'startTime': null,
                    'endTime': null,
                    'createdAt': DateTime.now(),
                  });
                });
                Navigator.pop(context);
              },
              child: busy
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _startRoute(Map<String, dynamic> r) {
    setState(() {
      r['status'] = 'active';
      r['startTime'] = DateTime.now();
      r['endTime'] = null;
    });
  }

  void _completeRoute(Map<String, dynamic> r) {
    setState(() {
      r['status'] = 'completed';
      r['endTime'] = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes Management'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _createRouteDialog, icon: const Icon(Icons.add_road), tooltip: 'Create Route'),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _routes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final r = _routes[i];
          final status = r['status'] as String;

          Color statusColor;
          switch (status) {
            case 'active':
              statusColor = Colors.teal.shade700;
              break;
            case 'completed':
              statusColor = const Color(0xFF2E7D32);
              break;
            default:
              statusColor = Colors.orange.shade700;
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
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.route, color: statusColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          r['routeName'] as String,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Driver: ${r['driverId']}', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text('Bins: ${(r['assignedBins'] as List).isEmpty ? 'None' : (r['assignedBins'] as List).join(', ')}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (status == 'scheduled')
                        TextButton.icon(
                          onPressed: () => _startRoute(r),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start'),
                        ),
                      if (status == 'active')
                        TextButton.icon(
                          onPressed: () => _completeRoute(r),
                          icon: const Icon(Icons.check),
                          label: const Text('Complete'),
                        ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => setState(() => _routes.removeAt(i)),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRouteDialog,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_road),
        label: const Text('New Route'),
      ),
    );
  }
}
