import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_login_viewmodel.dart';
import 'admin_main_screen.dart';

/// AdminLoginScreen — Login Admin terhubung SQLite
/// Path: lib/screens/admin/admin_login_screen.dart
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _viewModel = AdminLoginViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success =
        await _viewModel.login(_emailCtrl.text.trim(), _passCtrl.text);

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => AdminMainScreen(currentUser: _viewModel.user!)),
          (r) => false);
    } else if (_viewModel.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_viewModel.error!),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(28, 0, 28, MediaQuery.of(context).viewInsets.bottom + 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.admin_panel_settings,
                  color: Color(0xFFB8973A), size: 30),
            ),
            const SizedBox(height: 24),
            const Text('Admin Login',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Kelola seluruh platform E-BookStore.',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45), fontSize: 14)),
            const SizedBox(height: 16),
            // Demo hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFB8973A).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.25)),
              ),
              child: const Row(children: [
                Icon(Icons.info_outline, color: Color(0xFFB8973A), size: 16),
                SizedBox(width: 8),
                Text('Demo: admin@demo.com  /  admin123',
                    style: TextStyle(color: Color(0xFFB8973A), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 32),
            // Form
            Form(
              key: _formKey,
              child: Column(children: [
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Email tidak valid'
                      : null,
                  decoration: _fieldDec('Email', Icons.email_outlined),
                ),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min. 6 karakter' : null,
                  decoration: _fieldDec('Password', Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white38,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      )),
                ),
                const SizedBox(height: 32),
                // Submit
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _viewModel.loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8973A),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor:
                            const Color(0xFFB8973A).withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _viewModel.loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.black, strokeWidth: 2.5))
                          : const Text('Masuk',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration _fieldDec(String label, IconData icon, {Widget? suffix}) =>
      InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.45), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: const Color(0xFFB8973A).withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB8973A), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5)),
      );
}
