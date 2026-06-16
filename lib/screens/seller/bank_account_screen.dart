import 'package:flutter/material.dart';
import '../../models/user.dart';

class BankAccountScreen extends StatelessWidget {
  final User currentUser;
  const BankAccountScreen({super.key, required this.currentUser});

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
        title: const Text('Rekening Bank',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.account_balance,
                  color: Color(0xFFB8973A), size: 40),
            ),
          ),
          const SizedBox(height: 24),
          _bankCard(
            bankName: 'Bank Central Asia (BCA)',
            accountNumber: '123 456 7890',
            accountName: currentUser.nama,
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 12),
          _bankCard(
            bankName: 'Bank Mandiri',
            accountNumber: '098 765 4321',
            accountName: currentUser.nama,
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8973A),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Fitur tambah rekening akan segera hadir'),
                  backgroundColor: const Color(0xFF1A1A1A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ));
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Rekening',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankCard({
    required String bankName,
    required String accountNumber,
    required String accountName,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFB8973A).withValues(alpha: 0.1)),
      ),
      child: Column(children: [
        Row(children: [
          Icon(icon, color: const Color(0xFFB8973A), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(bankName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(accountNumber,
                  style: const TextStyle(
                      color: Color(0xFFB8973A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text('a.n. $accountName',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45), fontSize: 12)),
            ]),
          ),
          Icon(Icons.check_circle,
              color: const Color(0xFF4CAF50).withValues(alpha: 0.6), size: 20),
        ]),
      ]),
    );
  }
}
