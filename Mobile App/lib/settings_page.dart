import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifOverflow = true;
  bool _notifComplaint = true;
  bool _location = true;
  String _theme = 'system'; // light | dark | system
  String _language = 'en';  // en | hi

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const _SectionHeader('Notifications'),
          SwitchListTile.adaptive(
            title: const Text('Overflow near me'),
            subtitle: const Text('Alerts when nearby bins are full'),
            value: _notifOverflow,
            onChanged: (v) => setState(() => _notifOverflow = v),
          ),
          SwitchListTile.adaptive(
            title: const Text('Complaint updates'),
            subtitle: const Text('Get status change notifications'),
            value: _notifComplaint,
            onChanged: (v) => setState(() => _notifComplaint = v),
          ),
          const Divider(height: 24),

          const _SectionHeader('Privacy & Location'),
          SwitchListTile.adaptive(
            title: const Text('Allow location access'),
            subtitle: const Text('Enable “Find Bins” accuracy'),
            value: _location,
            onChanged: (v) => setState(() => _location = v),
          ),
          const Divider(height: 24),

          const _SectionHeader('Appearance'),
          RadioListTile<String>(
            title: const Text('System default'),
            value: 'system',
            groupValue: _theme,
            onChanged: (v) => setState(() => _theme = v!),
          ),
          RadioListTile<String>(
            title: const Text('Light'),
            value: 'light',
            groupValue: _theme,
            onChanged: (v) => setState(() => _theme = v!),
          ),
          RadioListTile<String>(
            title: const Text('Dark'),
            value: 'dark',
            groupValue: _theme,
            onChanged: (v) => setState(() => _theme = v!),
          ),
          const Divider(height: 24),

          const _SectionHeader('Language'),
          ListTile(
            leading: const Icon(Icons.translate_outlined),
            title: const Text('App language'),
            subtitle: Text(_language == 'en' ? 'English' : 'Hindi'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
              ],
              onChanged: (v) => setState(() => _language = v ?? 'en'),
            ),
          ),
          const Divider(height: 24),

          const _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About WasteWise'),
            subtitle: const Text('Version 1.0.0 •'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'WasteWise',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 WasteWise',
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}
