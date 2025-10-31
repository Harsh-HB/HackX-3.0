import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _busy = false;
  bool _showPass = false;
  String _role = 'citizen'; // citizen | government

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 350)); // simulate work
    if (!mounted) return;

    final route = _role == 'government' ? '/gov' : '/citizen';
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
                  ],
                ),
                child: const Icon(Icons.recycling, color: Colors.white, size: 56),
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome to WasteWise',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: primary),
              ),
              const SizedBox(height: 6),
              const Text('Smart Waste Management', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 28),

              // Form
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _decoration(
                        label: 'Email',
                        prefix: const Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return 'Enter email';
                        final re = RegExp(r'^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}$');
                        if (!re.hasMatch(s)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextFormField(
                      controller: _password,
                      obscureText: !_showPass,
                      decoration: _decoration(
                        label: 'Password',
                        prefix: const Icon(Icons.lock_outline),
                        suffix: IconButton(
                          tooltip: _showPass ? 'Hide' : 'Show',
                          onPressed: () => setState(() => _showPass = !_showPass),
                          icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 14),

                    // Role
                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: _decoration(
                        label: 'Role',
                        prefix: const Icon(Icons.account_circle_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'citizen', child: Text('Citizen')),
                        DropdownMenuItem(value: 'government', child: Text('Government Official')),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? 'citizen'),
                    ),
                    const SizedBox(height: 22),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _doLogin,
                        child: _busy
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : const Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Auxiliary actions (offline placeholders)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _busy ? null : () {},
                          child: const Text('Forgot Password?'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _busy ? null : () {},
                          child: const Text('Create Account'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration({required String label, Widget? prefix, Widget? suffix}) {
    const primary = Color(0xFF2E7D32);
    return InputDecoration(
      labelText: label,
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2),
      ),
    );
  }
}
