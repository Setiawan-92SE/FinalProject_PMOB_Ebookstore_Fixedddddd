import 'package:flutter/material.dart';
import '../../models/user.dart';

class StoreInfoScreen extends StatelessWidget {
  final User currentUser;
  const StoreInfoScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Informasi Toko',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.storefront,
                    color: Color(0xFFB8973A), size: 48),
              ),
              const SizedBox(height: 16),
              Text(currentUser.nama,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(currentUser.email,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 32),
          _infoCard(
            icon: Icons.store_outlined,
            title: 'Nama Toko',
            value: 'Toko ${currentUser.nama}',
          ),
          const SizedBox(height: 12),
          _infoCard(
            icon: Icons.description_outlined,
            title: 'Deskripsi Toko',
            value: 'Toko buku digital terpercaya. Menyediakan berbagai macam buku berkualitas.',
          ),
          const SizedBox(height: 12),
          _infoCard(
            icon: Icons.location_on_outlined,
            title: 'Alamat Toko',
            value: 'Belum diatur',
          ),
          const SizedBox(height: 12),
          _infoCard(
            icon: Icons.schedule_outlined,
            title: 'Jam Operasional',
            value: 'Senin - Jumat, 08:00 - 17:00',
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFB8973A).withValues(alpha: 0.1)),
      ),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFB8973A), size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45), fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      ]),
    );
  }
}
