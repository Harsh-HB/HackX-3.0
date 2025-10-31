import 'package:flutter/material.dart';

import 'bin_monitoring.dart';
import 'routes_management.dart';
import 'predictive_maintenance.dart';

class GovernmentDashboard extends StatelessWidget {
  const GovernmentDashboard({super.key});

  // Hardcoded metrics
  static const int totalBins = 128;
  static const int highFillBins = 17;
  static const int activeRoutes = 6;
  static const int pendingComplaints = 9;
  static const double avgFill = 58.4; // percent

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Dashboard'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Bin Monitoring',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BinMonitoring()),
            ),
            icon: const Icon(Icons.map_outlined),
          ),
          IconButton(
            tooltip: 'Routes',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoutesManagement()),
            ),
            icon: const Icon(Icons.route_outlined),
          ),
          IconButton(
            tooltip: 'Predictive',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictiveMaintenance()),
            ),
            icon: const Icon(Icons.auto_graph_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(title: 'Overview'),
          const SizedBox(height: 8),
          _StatCard(
            color: primary,
            icon: Icons.delete_outline,
            title: 'Total Bins',
            value: '$totalBins',
          ),
          const SizedBox(height: 12),
          _StatCard(
            color: Colors.red.shade600,
            icon: Icons.warning_amber_rounded,
            title: 'High Fill Bins',
            value: '$highFillBins',
          ),
          const SizedBox(height: 12),
          _StatCard(
            color: Colors.teal.shade700,
            icon: Icons.local_shipping_outlined,
            title: 'Active Routes',
            value: '$activeRoutes',
          ),
          const SizedBox(height: 12),
          _StatCard(
            color: Colors.orange.shade700,
            icon: Icons.report_problem_outlined,
            title: 'Pending Complaints',
            value: '$pendingComplaints',
          ),
          const SizedBox(height: 12),
          _ProgressCard(
            title: 'Average Bin Fill',
            percent: (avgFill / 100).clamp(0.0, 1.0),
            label: '${avgFill.toStringAsFixed(1)}%',
            color: Colors.indigo.shade700,
          ),
          const SizedBox(height: 16),
          const _SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  label: 'Monitor Bins',
                  icon: Icons.map,
                  color: primary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BinMonitoring()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  label: 'Manage Routes',
                  icon: Icons.route,
                  color: Colors.teal.shade700,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoutesManagement()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ActionTile(
            label: 'Predictive',
            icon: Icons.auto_graph,
            color: Colors.indigo.shade700,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictiveMaintenance()),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 90,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final double percent;
  final String label;
  final Color color;

  const _ProgressCard({
    required this.title,
    required this.percent,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: percent,
                color: color,
                backgroundColor: color.withOpacity(0.12),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
