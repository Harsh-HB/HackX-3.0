import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Guest User');
  final _email = TextEditingController(text: 'guest@example.com');
  final _phone = TextEditingController(text: '');
  final _address = TextEditingController(text: '');

  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: primary.withOpacity(0.12),
                  child: const Icon(Icons.person, size: 40, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change photo (demo)')),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Change photo'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _name,
                  decoration: _dec('Full name', const Icon(Icons.badge_outlined)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  readOnly: true,
                  decoration: _dec('Email (read-only)', const Icon(Icons.email_outlined)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: _dec('Phone', const Icon(Icons.phone_outlined)),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return null;
                    final re = RegExp(r'^[0-9+\-\s]{7,15}$');
                    return re.hasMatch(s) ? null : 'Enter a valid phone';
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address,
                  minLines: 2,
                  maxLines: 4,
                  decoration: _dec('Address', const Icon(Icons.home_outlined)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _save,
                    child: _busy
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Save Changes', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label, Icon prefix) {
    const primary = Color(0xFF2E7D32);
    return InputDecoration(
      labelText: label,
      prefixIcon: prefix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2),
      ),
    );
  }
}
