import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../welcome_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/change_password_screen.dart';
import '../shared/notifications_screen.dart';
import '../shared/help_screen.dart';
import '../shared/about_app_screen.dart';

/// AdminProfileScreen — Profil Admin
/// Path: lib/screens/admin/admin_profile_screen.dart
class AdminProfileScreen extends StatelessWidget {
  final User currentUser;
  const AdminProfileScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          children: [
            const Text('Profil Admin',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 28),

            // Avatar
            Center(
                child: Column(children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  border:
                      Border.all(color: const Color(0xFFB8973A), width: 2.5),
                ),
                child: const Icon(Icons.admin_panel_settings,
                    color: Color(0xFFB8973A), size: 44),
              ),
              const SizedBox(height: 14),
              Text(currentUser.nama,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(currentUser.email,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13)),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.35)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.verified_user, color: Color(0xFFB8973A), size: 14),
                  SizedBox(width: 6),
                  Text('Super Administrator',
                      style: TextStyle(
                          color: Color(0xFFB8973A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ])),
            const SizedBox(height: 32),

            // Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.12)),
              ),
              child: Column(children: [
                _InfoRow(
                    icon: Icons.person_outline,
                    label: 'Nama',
                    value: currentUser.nama),
                const _Divider(),
                _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: currentUser.email),
                const _Divider(),
                _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'No. HP',
                    value: currentUser.phone),
                const _Divider(),
                _InfoRow(
                    icon: Icons.shield_outlined,
                    label: 'Role',
                    value: 'Administrator'),
              ]),
            ),
            const SizedBox(height: 24),

            const _MenuHeader('Pengaturan'),
            const SizedBox(height: 10),
            _MenuTile(
                icon: Icons.person_outline,
                label: 'Edit Profil',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                            currentUser: currentUser)))),
            _MenuTile(
                icon: Icons.lock_outline,
                label: 'Ubah Password',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChangePasswordScreen(
                            currentUser: currentUser)))),
            _MenuTile(
                icon: Icons.notifications_outlined,
                label: 'Notifikasi',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const NotificationsScreen(role: 'admin')))),
            const SizedBox(height: 20),

            const _MenuHeader('Lainnya'),
            const SizedBox(height: 10),
            _MenuTile(
                icon: Icons.help_outline,
                label: 'Bantuan',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const HelpScreen(role: 'admin')))),
            _MenuTile(
                icon: Icons.info_outline,
                label: 'Tentang Aplikasi',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const AboutAppScreen(role: 'admin')))),
            const SizedBox(height: 8),
            _MenuTile(
              icon: Icons.logout,
              label: 'Keluar',
              iconColor: Colors.red,
              labelColor: Colors.red,
              showArrow: false,
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext ctx) => showDialog(
      context: ctx,
      builder: (dCtx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text('Konfirmasi Logout',
                style: TextStyle(color: Colors.white)),
            content: const Text('Yakin ingin keluar dari akun Admin?',
                style: TextStyle(color: Colors.white60)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dCtx),
                  child: const Text('Batal',
                      style: TextStyle(color: Colors.white54))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      ctx,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (_) => false),
                  child: const Text('Keluar')),
            ],
          ));
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFB8973A), size: 18),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45), fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ]));
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) =>
      Divider(color: Colors.white.withValues(alpha: 0.06), height: 1);
}

class _MenuHeader extends StatelessWidget {
  final String text;
  const _MenuHeader(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: Colors.white60,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5));
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color labelColor;
  final bool showArrow;
  const _MenuTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.iconColor = const Color(0xFFB8973A),
      this.labelColor = Colors.white,
      this.showArrow = true});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              const Color(0xFFB8973A).withValues(alpha: 0.1))),
                  child: Row(children: [
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Text(label,
                            style: TextStyle(color: labelColor, fontSize: 15))),
                    if (showArrow)
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white.withValues(alpha: 0.2), size: 14),
                  ])))));
}