import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../welcome_screen.dart';
import 'buyer_wishlist_screen.dart';

class BuyerProfileScreen extends StatelessWidget {
  final User currentUser;
  const BuyerProfileScreen({super.key, required this.currentUser});

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
            Center(
                child: Column(children: [
              Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(
                          color: const Color(0xFFB8973A), width: 2.5)),
                  child: const Icon(Icons.person,
                      color: Color(0xFFB8973A), size: 44)),
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              const Color(0xFFB8973A).withValues(alpha: 0.3))),
                  child: const Text('📚 Buyer',
                      style: TextStyle(
                          color: Color(0xFFB8973A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
            ])),
            const SizedBox(height: 28),
            const Text('Akun Saya',
                style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
            const SizedBox(height: 10),
            _Tile(
                icon: Icons.favorite_border,
                label: 'Wish-list',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            BuyerWishlistScreen(currentUser: currentUser)))),
            _Tile(
                icon: Icons.receipt_long_outlined,
                label: 'Riwayat Pesanan',
                onTap: () {}),
            _Tile(
                icon: Icons.person_outline, label: 'Edit Profil', onTap: () {}),
            _Tile(
                icon: Icons.notifications_outlined,
                label: 'Notifikasi',
                onTap: () {}),
            const SizedBox(height: 20),
            const Text('Lainnya',
                style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
            const SizedBox(height: 10),
            _Tile(icon: Icons.help_outline, label: 'Bantuan', onTap: () {}),
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

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color labelColor;
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
