import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final String role;
  const NotificationsScreen({super.key, required this.role});

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
        title: const Text('Notifikasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none,
                color: Colors.white.withValues(alpha: 0.15), size: 72),
            const SizedBox(height: 16),
            Text('Belum ada notifikasi',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3), fontSize: 16)),
            const SizedBox(height: 4),
            Text('Notifikasi akan muncul di sini',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.2), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
