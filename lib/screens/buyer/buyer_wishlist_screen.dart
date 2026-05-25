import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../viewmodels/buyer/buyer_wishlist_viewmodel.dart';

class BuyerWishlistScreen extends StatefulWidget {
  final User currentUser;
  const BuyerWishlistScreen({super.key, required this.currentUser});
  @override
  State<BuyerWishlistScreen> createState() => _BuyerWishlistScreenState();
}

class _BuyerWishlistScreenState extends State<BuyerWishlistScreen> {
  final _viewModel = BuyerWishlistViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.load(widget.currentUser.id!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context)),
          title: const Text('Wish-list',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
      body: _viewModel.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB8973A)))
          : _viewModel.books.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.favorite_border,
                      color: Colors.white12, size: 72),
                  const SizedBox(height: 16),
                  const Text('Wish-list kosong',
                      style: TextStyle(color: Colors.white38, fontSize: 16)),
                ]))
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: _viewModel.books.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final b = _viewModel.books[i];
                    return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFB8973A)
                                    .withValues(alpha: 0.12))),
                        child: Row(children: [
                          Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFB8973A)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.menu_book_outlined,
                                  color: Color(0xFFB8973A), size: 26)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(b.judul,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(b.penulis,
                                    style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.4),
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('Rp ${_fmt(b.harga.toInt())}',
                                    style: const TextStyle(
                                        color: Color(0xFFB8973A),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ])),
                          IconButton(
                              icon: const Icon(Icons.favorite,
                                  color: Colors.red, size: 22),
                              onPressed: () async {
                                await _viewModel.remove(
                                    widget.currentUser.id!, b.id!);
                              }),
                        ]));
                  }),
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
