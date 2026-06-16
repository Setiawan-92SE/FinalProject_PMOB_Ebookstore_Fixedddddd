import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  final String role;
  const AboutAppScreen({super.key, required this.role});

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
        title: const Text('Tentang Aplikasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.auto_stories,
                    color: Color(0xFFB8973A), size: 44),
              ),
              const SizedBox(height: 16),
              const Text('E-BookStore',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Versi 1.0.0',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
              const SizedBox(height: 8),
              Text('Platform jual-beli buku digital.',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                  textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 32),
          const _SectionHeader('Profil Tim Pengembang Aplikasi Ebookstore'),
          const SizedBox(height: 12),
          _TeamMember('David Mahlon Sarumaha', '24082010126'),
          _TeamMember('Putu Pramudya Pratama', '24082010113'),
          _TeamMember('Ganesha Setiawan', '24082010092'),
          _TeamMember('Choirul Wahyu Adji', '24082010122'),
          const SizedBox(height: 24),
          const _SectionHeader('Dosen Pembimbing'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.1)),
            ),
            child: Row(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school,
                    color: Color(0xFFB8973A), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Iqbal Ramadhani Mukhlis, S.Kom., M.Kom.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('Dosen Pembimbing',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12)),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: Color(0xFFB8973A),
          fontSize: 14,
          fontWeight: FontWeight.w600));
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String nim;
  const _TeamMember(this.name, this.nim);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFB8973A).withValues(alpha: 0.1)),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFB8973A).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Color(0xFFB8973A), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text('NIM: $nim',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }
}
