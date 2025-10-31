import 'package:flutter/material.dart';

class ComplaintStatus extends StatefulWidget {
  const ComplaintStatus({super.key});

  @override
  State<ComplaintStatus> createState() => _ComplaintStatusState();
}

class _ComplaintStatusState extends State<ComplaintStatus> {
  // Hardcoded complaints
  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'C-001',
      'type': 'overflow',
      'description': 'Bin near City Mall is overflowing.',
      'status': 'pending', // pending | assigned | resolved
      'timestamp': DateTime.now().subtract(const Duration(hours: 3, minutes: 20)),
    },
    {
      'id': 'C-002',
      'type': 'uncollected',
      'description': 'Garbage not collected from Sector 12.',
      'status': 'assigned',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8, minutes: 5)),
    },
    {
      'id': 'C-003',
      'type': 'maintenance',
      'description': 'Damaged lid at Metro Station North.',
      'status': 'resolved',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    },
  ];

  void _advanceStatus(Map<String, dynamic> c) {
    setState(() {
      final s = c['status'] as String;
      if (s == 'pending') {
        c['status'] = 'assigned';
      } else if (s == 'assigned') {
        c['status'] = 'resolved';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _complaints.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final d = _complaints[i];
          final type = d['type'] as String;
          final status = d['status'] as String;
          final desc = d['description'] as String;
          final ts = d['timestamp'] as DateTime;

          Color statusColor;
          switch (status) {
            case 'resolved':
              statusColor = const Color(0xFF2E7D32);
              break;
            case 'assigned':
              statusColor = Colors.teal.shade700;
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
                        child: Icon(Icons.assignment_outlined, color: statusColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          type.toUpperCase(),
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
                  const SizedBox(height: 10),
                  Text(desc),
                  const SizedBox(height: 8),
                  Text(_fmt(ts), style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 10),
                  if (status != 'resolved')
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _advanceStatus(d),
                        icon: const Icon(Icons.update),
                        label: const Text('Advance Status'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _fmt(DateTime dt) {
    final d = dt.toLocal();
    return '${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}';
  }

  String _two(int v) => v < 10 ? '0$v' : '$v';
}
