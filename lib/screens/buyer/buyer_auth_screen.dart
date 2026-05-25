import 'package:flutter/material.dart';
import '../../viewmodels/buyer/buyer_auth_viewmodel.dart';
import 'buyer_main_screen.dart';

class BuyerAuthScreen extends StatefulWidget {
  const BuyerAuthScreen({super.key});

  @override
  State<BuyerAuthScreen> createState() => _BuyerAuthScreenState();
}

class _BuyerAuthScreenState extends State<BuyerAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _viewModel = BuyerAuthViewModel();

  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();
  bool _loginObscure = true;
  final _loginKey = GlobalKey<FormState>();

  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPhoneCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regConfirmCtrl = TextEditingController();
  bool _regObscure = true;
  bool _regConfirmObscure = true;
  final _regKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewModel.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPhoneCtrl.dispose();
    _regPassCtrl.dispose();
    _regConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_loginKey.currentState!.validate()) return;

    final success = await _viewModel.login(
        _loginEmailCtrl.text.trim(), _loginPassCtrl.text);

    if (!mounted) return;

    if (success && _viewModel.user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => BuyerMainScreen(currentUser: _viewModel.user!)),
        (route) => false,
      );
    } else if (_viewModel.error != null) {
      _showSnack(_viewModel.error!, isError: true);
    }
  }

  Future<void> _doRegister() async {
    if (!_regKey.currentState!.validate()) return;

    final success = await _viewModel.register(
      _regNameCtrl.text.trim(),
      _regEmailCtrl.text.trim(),
      _regPhoneCtrl.text.trim(),
      _regPassCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      _showSnack('Akun Buyer berhasil dibuat! Silakan login.');
      _regNameCtrl.clear();
      _regEmailCtrl.clear();
      _regPhoneCtrl.clear();
      _regPassCtrl.clear();
      _regConfirmCtrl.clear();
      _tabController.animateTo(0);
    } else if (_viewModel.error != null) {
      _showSnack(_viewModel.error!, isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade700 : const Color(0xFFB8973A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
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
        title: Row(children: [
          const Icon(Icons.person_outline, color: Color(0xFFB8973A), size: 20),
          const SizedBox(width: 8),
          const Text('Buyer',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
      ),
      body: Column(
        children: [
          _DemoHint(text: 'Demo: buyer@demo.com  /  buyer123'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              height: 46,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.15),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: const Color(0xFFB8973A),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Login'),
                  Tab(text: 'Daftar'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BuyerLoginTab(
                  formKey: _loginKey,
                  emailCtrl: _loginEmailCtrl,
                  passCtrl: _loginPassCtrl,
                  obscure: _loginObscure,
                  loading: _viewModel.loading,
                  onToggle: () =>
                      setState(() => _loginObscure = !_loginObscure),
                  onLogin: _doLogin,
                ),
                _BuyerRegisterTab(
                  formKey: _regKey,
                  nameCtrl: _regNameCtrl,
                  emailCtrl: _regEmailCtrl,
                  phoneCtrl: _regPhoneCtrl,
                  passCtrl: _regPassCtrl,
                  confirmCtrl: _regConfirmCtrl,
                  passRef: _regPassCtrl,
                  obscure: _regObscure,
                  confirmObscure: _regConfirmObscure,
                  loading: _viewModel.loading,
                  onTogglePass: () =>
                      setState(() => _regObscure = !_regObscure),
                  onToggleConfirm: () =>
                      setState(() => _regConfirmObscure = !_regConfirmObscure),
                  onRegister: _doRegister,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerLoginTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final bool loading;
  final VoidCallback onToggle;
  final VoidCallback onLogin;

  const _BuyerLoginTab({
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.loading,
    required this.onToggle,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(28, 28, 28, MediaQuery.of(context).viewInsets.bottom + 40),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Pembaca! 📚',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Login untuk mengakses koleksi buku.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            _BuyerField(
              controller: emailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Email tidak valid' : null,
            ),
            const SizedBox(height: 14),
            _BuyerField(
              controller: passCtrl,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white38,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
              validator: (v) =>
                  v == null || v.length < 6 ? 'Min. 6 karakter' : null,
            ),
            const SizedBox(height: 28),
            _BuyerButton(label: 'Login', loading: loading, onPressed: onLogin),
          ],
        ),
      ),
    );
  }
}

class _BuyerRegisterTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController passCtrl;
  final TextEditingController confirmCtrl;
  final TextEditingController passRef;
  final bool obscure;
  final bool confirmObscure;
  final bool loading;
  final VoidCallback onTogglePass;
  final VoidCallback onToggleConfirm;
  final VoidCallback onRegister;

  const _BuyerRegisterTab({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passCtrl,
    required this.confirmCtrl,
    required this.passRef,
    required this.obscure,
    required this.confirmObscure,
    required this.loading,
    required this.onTogglePass,
    required this.onToggleConfirm,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(28, 28, 28, MediaQuery.of(context).viewInsets.bottom + 40),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Sekarang\n& Mulai Membaca',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat akun buyer dan temukan buku favoritmu.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            _BuyerField(
              controller: nameCtrl,
              label: 'Nama Lengkap',
              icon: Icons.person_outline,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            _BuyerField(
              controller: emailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Email tidak valid' : null,
            ),
            const SizedBox(height: 14),
            _BuyerField(
              controller: phoneCtrl,
              label: 'Nomor HP',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.length < 10 ? 'Nomor HP tidak valid' : null,
            ),
            const SizedBox(height: 14),
            _BuyerField(
              controller: passCtrl,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white38,
                  size: 20,
                ),
                onPressed: onTogglePass,
              ),
              validator: (v) =>
                  v == null || v.length < 6 ? 'Min. 6 karakter' : null,
            ),
            const SizedBox(height: 14),
            _BuyerField(
              controller: confirmCtrl,
              label: 'Konfirmasi Password',
              icon: Icons.lock_outline,
              obscure: confirmObscure,
              suffixIcon: IconButton(
                icon: Icon(
                  confirmObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white38,
                  size: 20,
                ),
                onPressed: onToggleConfirm,
              ),
              validator: (v) =>
                  v != passRef.text ? 'Password tidak cocok' : null,
            ),
            const SizedBox(height: 28),
            _BuyerButton(
                label: 'Daftar', loading: loading, onPressed: onRegister),
          ],
        ),
      ),
    );
  }
}

class _BuyerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _BuyerField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.45), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: const Color(0xFFB8973A).withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB8973A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _DemoHint extends StatelessWidget {
  final String text;
  const _DemoHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFB8973A).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: const Color(0xFFB8973A).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFB8973A), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Color(0xFFB8973A), fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _BuyerButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _BuyerButton(
      {required this.label, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB8973A),
          foregroundColor: Colors.black,
          disabledBackgroundColor:
              const Color(0xFFB8973A).withValues(alpha: 0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.black, strokeWidth: 2.5))
            : Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
