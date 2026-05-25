import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/user.dart';
import '../../viewmodels/buyer/buyer_book_detail_viewmodel.dart';

// ═══════════════════════════════════════════════════════════════════════════
// BOOK DETAIL
// Path: lib/screens/buyer/buyer_book_detail_screen.dart
// ═══════════════════════════════════════════════════════════════════════════
class BuyerBookDetailScreen extends StatefulWidget {
  final Book book;
  final User currentUser;
  const BuyerBookDetailScreen(
      {super.key, required this.book, required this.currentUser});

  @override
  State<BuyerBookDetailScreen> createState() => _BuyerBookDetailScreenState();
}

class _BuyerBookDetailScreenState extends State<BuyerBookDetailScreen> {
  final _viewModel = BuyerBookDetailViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.checkState(widget.currentUser.id!, widget.book);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _toggleWish() async {
    if (widget.book.id == null) return;
    await _viewModel.toggleWishlist(widget.currentUser.id!, widget.book.id!);
  }

  Future<void> _addToCart() async {
    if (widget.book.id == null) return;
    await _viewModel.addToCart(widget.currentUser.id!, widget.book.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Ditambahkan ke keranjang!'),
        backgroundColor: const Color(0xFFB8973A),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.book;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
              icon: Icon(_viewModel.inWish ? Icons.favorite : Icons.favorite_border,
                  color: _viewModel.inWish ? Colors.red : const Color(0xFFB8973A)),
              onPressed: _toggleWish)
        ],
      ),
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
            // Cover
            Center(
                child: Container(
                    width: 160,
                    height: 200,
                    decoration: BoxDecoration(
                        color: const Color(0xFFB8973A).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFB8973A)
                                .withValues(alpha: 0.2))),
                    child: const Icon(Icons.menu_book,
                        color: Color(0xFFB8973A), size: 80))),
            const SizedBox(height: 24),
            Text(b.judul,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(b.penulis,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5), fontSize: 15),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _InfoChip(label: b.kategori, icon: Icons.label_outline),
              const SizedBox(width: 8),
              _InfoChip(
                  label: 'Stok: ${b.stok}', icon: Icons.inventory_2_outlined),
            ]),
            const SizedBox(height: 20),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color:
                            const Color(0xFFB8973A).withValues(alpha: 0.12))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Deskripsi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(b.deskripsi,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                              height: 1.6)),
                    ])),
            const SizedBox(height: 20),
            // Qty selector
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  onPressed: () {
                    if (_viewModel.qty > 1) _viewModel.setQty(_viewModel.qty - 1);
                  },
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Color(0xFFB8973A), size: 28)),
              Container(
                  width: 48,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${_viewModel.qty}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center)),
              IconButton(
                  onPressed: () {
                    if (_viewModel.qty < b.stok) _viewModel.setQty(_viewModel.qty + 1);
                  },
                  icon: const Icon(Icons.add_circle_outline,
                      color: Color(0xFFB8973A), size: 28)),
            ]),
            const SizedBox(height: 8),
            Text('Total: Rp ${_fmt((b.harga * _viewModel.qty).toInt())}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: _viewModel.inCart ? null : _addToCart,
                icon: Icon(_viewModel.inCart ? Icons.check : Icons.shopping_cart_outlined,
                    size: 20),
                label: Text(
                    _viewModel.inCart ? 'Sudah di Keranjang' : 'Tambah ke Keranjang'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _viewModel.inCart
                        ? Colors.green.shade700
                        : const Color(0xFFB8973A),
                    foregroundColor: _viewModel.inCart ? Colors.white : Colors.black,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0)),
          ])),
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFB8973A).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFFB8973A).withValues(alpha: 0.25))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: const Color(0xFFB8973A), size: 14),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Color(0xFFB8973A), fontSize: 12)),
      ]));
}
