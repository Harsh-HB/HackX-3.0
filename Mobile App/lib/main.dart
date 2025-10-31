import 'package:flutter/material.dart';

// Flat single-folder imports
import 'login.dart';            // <-- add this
import 'splash.dart';
import 'gov_dashboard.dart';
import 'citizen_home.dart';
import 'bin_monitoring.dart';
import 'routes_management.dart';
import 'predictive_maintenance.dart';
import 'report_waste.dart';
import 'complaint_status.dart';
import 'bin_locator.dart';
import 'profile_page.dart';
import 'settings_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WasteWiseApp());
}

class WasteWiseApp extends StatelessWidget {
  const WasteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);

    return MaterialApp(
      title: 'WasteWise',
      debugShowCheckedModeBanner: false,
      // English-only setup (no delegates needed)
      supportedLocales: const [Locale('en')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
      // Start on login
      initialRoute: '/login',
      routes: {
        '/login': (_) => const Login(),                // <-- added route
        '/splash': (_) => const Splash(),
        '/gov': (_) => const GovernmentDashboard(),
        '/citizen': (_) => const CitizenHome(),
        '/bins': (_) => const BinMonitoring(),
        '/routes': (_) => const RoutesManagement(),
        '/predictive': (_) => const PredictiveMaintenance(),
        '/report': (_) => const ReportWaste(),
        '/complaints': (_) => const ComplaintStatus(),
        '/locator': (_) => const BinLocator(),
        '/profile': (_) => const ProfilePage(),
        '/settings': (_) => const SettingsPage(),
      },
    );
  }
}
