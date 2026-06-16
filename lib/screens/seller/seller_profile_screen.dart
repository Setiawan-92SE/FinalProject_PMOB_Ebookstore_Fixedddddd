import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../welcome_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/notifications_screen.dart';
import '../shared/help_screen.dart';
import '../shared/about_app_screen.dart';
import 'store_info_screen.dart';
import 'bank_account_screen.dart';

/// SellerProfileScreen — Profil Seller
/// Path: lib/screens/seller/seller_profile_screen.dart
class SellerProfileScreen extends StatelessWidget {
  final User currentUser;
  const SellerProfileScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              children: [
            const Text('Profil',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 28),
            // Avatar
            Center(
                child: Column(children: [
              Stack(children: [
                Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1A1A),
                        border: Border.all(
                            color: const Color(0xFFB8973A), width: 2.5)),
                    child: const Icon(Icons.storefront,
                        color: Color(0xFFB8973A), size: 44)),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            color: const Color(0xFFB8973A),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF0F0F0F), width: 2)),
                        child: const Icon(Icons.edit,
                            color: Colors.black, size: 13))),
              ]),
              const SizedBox(height: 12),
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
                          color:
                              const Color(0xFFB8973A).withValues(alpha: 0.3))),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.storefront_outlined,
                        color: Color(0xFFB8973A), size: 14),
                    SizedBox(width: 6),
                    Text('Seller Terverifikasi',
                        style: TextStyle(
                            color: Color(0xFFB8973A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ])),
            ])),
            const SizedBox(height: 24),
            // Info card
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color:
                            const Color(0xFFB8973A).withValues(alpha: 0.12))),
                child: Column(children: [
                  _InfoRow(Icons.person_outline, 'Nama', currentUser.nama),
                  _Div(),
                  _InfoRow(Icons.email_outlined, 'Email', currentUser.email),
                  _Div(),
                  _InfoRow(Icons.phone_outlined, 'No. HP', currentUser.phone),
                  _Div(),
                  _InfoRow(Icons.storefront_outlined, 'Role', 'Seller'),
                ])),
            const SizedBox(height: 24),
            const _Lbl('Pengaturan Toko'),
            const SizedBox(height: 10),
            _Tile(
                icon: Icons.person_outline,
                label: 'Edit Profil',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                            currentUser: currentUser)))),
            _Tile(
                icon: Icons.storefront_outlined,
                label: 'Informasi Toko',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StoreInfoScreen(
                            currentUser: currentUser)))),
            _Tile(
                icon: Icons.account_balance_outlined,
                label: 'Rekening Bank',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BankAccountScreen(
                            currentUser: currentUser)))),
            _Tile(
                icon: Icons.notifications_outlined,
                label: 'Notifikasi',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(
                            role: 'seller')))),
            const SizedBox(height: 20),
            const _Lbl('Lainnya'),
            const SizedBox(height: 10),
            _Tile(
                icon: Icons.help_outline,
                label: 'Bantuan',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const HelpScreen(role: 'seller')))),
            _Tile(
                icon: Icons.info_outline,
                label: 'Tentang Aplikasi',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const AboutAppScreen(role: 'seller')))),
            const SizedBox(height: 8),
            _Tile(
                icon: Icons.logout,
                label: 'Keluar',
                iconColor: Colors.red,
                labelColor: Colors.red,
                showArrow: false,
                onTap: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF1A1A1A),
                            title: const Text('Konfirmasi',
                                style: TextStyle(color: Colors.white)),
                            content: const Text('Yakin ingin keluar?',
                                style: TextStyle(color: Colors.white60)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Batal',
                                      style: TextStyle(color: Colors.white54))),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  onPressed: () => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const WelcomeScreen()),
                                      (_) => false),
                                  child: const Text('Keluar')),
                            ]))),
          ])),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);
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

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(color: Colors.white.withValues(alpha: 0.06), height: 1);
}

class _Lbl extends StatelessWidget {
  final String text;
  const _Lbl(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: Colors.white60,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5));
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor, labelColor;
  final bool showArrow;
  const _Tile(
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