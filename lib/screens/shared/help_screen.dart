import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final String role;
  const HelpScreen({super.key, required this.role});

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
        title: const Text('Bantuan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _header(role),
          const SizedBox(height: 16),
          if (role == 'seller') ..._sellerFaq(context),
          if (role == 'buyer') ..._buyerFaq(context),
          if (role == 'admin') ..._adminFaq(context),
          const SizedBox(height: 8),
          _contactCard(context),
        ],
      ),
    );
  }

  Widget _header(String role) {
    String title, subtitle;
    IconData icon;
    switch (role) {
      case 'seller':
        title = 'Pusat Bantuan Seller';
        subtitle = 'Panduan mengelola toko dan buku Anda';
        icon = Icons.storefront_outlined;
      case 'admin':
        title = 'Pusat Bantuan Admin';
        subtitle = 'Panduan mengelola platform E-BookStore';
        icon = Icons.admin_panel_settings_outlined;
      default:
        title = 'Pusat Bantuan Pembeli';
        subtitle = 'Panduan berbelanja buku di E-BookStore';
        icon = Icons.help_outline;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFB8973A).withValues(alpha: 0.15)),
      ),
      child: Row(children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFB8973A).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFFB8973A), size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45), fontSize: 13)),
          ]),
        ),
      ]),
    );
  }

  List<Widget> _sellerFaq(BuildContext context) => [
        _faqItem(context, 'Bagaimana cara menambahkan buku baru?',
            'Buka tab "Buku Saya", tekan tombol "+" di pojok kanan bawah. Isi judul, penulis, kategori, harga, stok, dan deskripsi buku. Setelah disimpan, buku akan masuk ke status "Pending" dan menunggu persetujuan Admin.'),
        _faqItem(context, 'Mengapa buku saya masih berstatus "Pending"?',
            'Setiap buku baru harus disetujui oleh Admin terlebih dahulu sebelum muncul di katalog pembeli. Silakan tunggu proses review atau hubungi Admin jika sudah lebih dari 2x24 jam.'),
        _faqItem(context, 'Bagaimana cara mengelola stok buku?',
            'Buka "Buku Saya", pilih buku yang ingin diedit, ubah jumlah stok sesuai ketersediaan, lalu simpan. Pastikan stok selalu diperbarui agar tidak terjadi kehabisan saat ada pesanan.'),
        _faqItem(context, 'Bagaimana cara melihat pesanan masuk?',
            'Buka tab "Pesanan" untuk melihat daftar pesanan dari pembeli. Anda dapat melihat detail pesanan, status pembayaran, dan memperbarui status pengiriman.'),
        _faqItem(context, 'Bagaimana cara melihat pendapatan?',
            'Buka tab "Pendapatan" untuk melihat ringkasan pendapatan, total penjualan, dan grafik pendapatan harian/bulanan.'),
        _faqItem(context, 'Bagaimana cara memperbarui profil toko?',
            'Buka halaman Profil, pilih menu "Edit Profil" untuk mengubah nama, email, atau nomor HP. Untuk informasi toko, pilih "Informasi Toko".'),
        _faqItem(context, 'Bagaimana cara menambahkan rekening bank?',
            'Buka halaman Profil, pilih "Rekening Bank", lalu tekan tombol "Tambah Rekening" untuk memasukkan data rekening pencairan dana.'),
        _faqItem(context, 'Apa yang harus dilakukan jika ada pembeli komplain?',
            'Hubungi pembeli melalui informasi kontak yang tersedia di detail pesanan. Jika tidak ada solusi, Anda dapat melibatkan Admin untuk mediasi.'),
      ];

  List<Widget> _buyerFaq(BuildContext context) => [
        _faqItem(context, 'Bagaimana cara mencari buku?',
            'Gunakan kolom pencarian di halaman Home atau jelajahi buku berdasarkan kategori melalui tab "Katalog". Anda juga bisa mencari berdasarkan judul atau penulis.'),
        _faqItem(context, 'Bagaimana cara memesan buku?',
            'Pilih buku yang diinginkan, tekan tombol "Beli Sekarang" untuk langsung checkout, atau tekan "Masukkan Keranjang" untuk belanja nanti.'),
        _faqItem(context, 'Bagaimana cara melihat isi keranjang?',
            'Buka tab "Keranjang" untuk melihat semua buku yang sudah Anda masukkan. Anda dapat mengubah jumlah atau menghapus buku sebelum checkout.'),
        _faqItem(context, 'Bagaimana cara melakukan pembayaran?',
            'Setelah checkout, pilih metode pembayaran yang tersedia. Status pembayaran dapat dilihat di halaman "Riwayat Pesanan".'),
        _faqItem(context, 'Bagaimana cara melihat riwayat pesanan?',
            'Buka halaman Profil, pilih menu "Riwayat Pesanan" untuk melihat semua pesanan yang sudah Anda buat beserta statusnya.'),
        _faqItem(context, 'Bagaimana cara menambahkan buku ke wishlist?',
            'Di halaman detail buku, tekan ikon hati (wishlist) untuk menyimpan buku ke daftar keinginan. Akses wishlist melalui menu di halaman Profil.'),
        _faqItem(context, 'Apakah bisa membatalkan pesanan?',
            'Pesanan dapat dibatalkan selama status masih "Pending" dan pembayaran belum dilakukan. Hubungi dukungan untuk pembatalan lebih lanjut.'),
        _faqItem(context, 'Bagaimana cara menghubungi penjual?',
            'Informasi penjual dapat dilihat di halaman detail buku. Anda juga bisa menghubungi melalui email yang tercantum.'),
      ];

  List<Widget> _adminFaq(BuildContext context) => [
        _faqItem(context, 'Bagaimana cara mengelola pengguna?',
            'Buka tab "Pengguna" untuk melihat daftar semua pengguna (Seller dan Buyer). Anda dapat mengaktifkan atau menonaktifkan akun, serta melihat detail pengguna.'),
        _faqItem(context, 'Bagaimana cara menyetujui atau menolak buku?',
            'Buka tab "Daftar Buku", filter berdasarkan status "Pending". Tekan tombol "Setujui" untuk menerbitkan buku atau "Tolak" jika buku tidak memenuhi ketentuan.'),
        _faqItem(context, 'Apa yang dimaksud dengan dashboard?',
            'Dashboard menampilkan ringkasan statistik platform seperti total pengguna, jumlah seller/buyer, total buku, buku yang disetujui/ditolak, jumlah pesanan, dan pendapatan.'),
        _faqItem(context, 'Bagaimana cara melihat laporan pesanan?',
            'Semua pesanan dari seluruh seller dapat dilihat di menu Dashboard. Anda dapat memonitor status pesanan dan pembayaran secara real-time.'),
        _faqItem(context, 'Bagaimana cara menambahkan kategori buku?',
            'Saat ini kategori buku sudah tersedia (Fiksi, Non-Fiksi, Pengembangan Diri, Pendidikan, Teknologi, Bisnis). Penambahan kategori baru dapat dilakukan melalui pengaturan database.'),
        _faqItem(context, 'Apa yang harus dilakukan jika ada laporan penyalahgunaan?',
            'Nonaktifkan sementara akun yang dilaporkan melalui tab "Pengguna", lakukan investigasi, dan ambil tindakan sesuai kebijakan platform.'),
        _faqItem(context, 'Bagaimana cara mengubah password?',
            'Buka halaman Profil, pilih menu "Ubah Password". Masukkan password lama dan password baru, lalu simpan.'),
        _faqItem(context, 'Bagaimana cara menghubungi pengembang?',
            'Untuk masalah teknis atau pengembangan fitur, hubungi tim pengembang melalui informasi yang tersedia di halaman "Tentang Aplikasi".'),
      ];

  Widget _contactCard(BuildContext context) {
    return Container(
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
          child: const Icon(Icons.mail_outline,
              color: Color(0xFFB8973A), size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Butuh bantuan lebih lanjut?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text('Hubungi kami di support@ebookstore.app',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45), fontSize: 12)),
          ]),
        ),
      ]),
    );
  }

  Widget _faqItem(BuildContext context, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFB8973A).withValues(alpha: 0.1)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          collapsedIconColor: const Color(0xFFB8973A),
          iconColor: const Color(0xFFB8973A),
          title: Text(question,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          children: [
            Text(answer,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
