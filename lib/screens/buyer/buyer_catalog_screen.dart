import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/user.dart';
import '../../repositories/wishlist_repository.dart';
import '../../viewmodels/buyer/buyer_catalog_viewmodel.dart';
import 'buyer_book_detail_screen.dart';

/// BuyerCatalogScreen — Katalog buku dengan filter kategori
/// Path: lib/screens/buyer/buyer_catalog_screen.dart
class BuyerCatalogScreen extends StatefulWidget {
  final User currentUser;
  const BuyerCatalogScreen({super.key, required this.currentUser});

  @override
  State<BuyerCatalogScreen> createState() => _BuyerCatalogScreenState();
}

class _BuyerCatalogScreenState extends State<BuyerCatalogScreen> {
  final _viewModel = BuyerCatalogViewModel();
  String _sortBy = 'nama'; // nama | harga_asc | harga_desc

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.load();
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  const Text(
                    'Katalog Buku',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    color: const Color(0xFF1A1A1A),
                    icon: const Icon(Icons.sort, color: Color(0xFFB8973A)),
                    onSelected: (v) {
                      setState(() => _sortBy = v);
                      _viewModel.setSortBy(v);
                    },
                    itemBuilder: (_) => [
                      _sortItem('nama', 'Nama A-Z', _sortBy),
                      _sortItem('harga_asc', 'Harga Terendah', _sortBy),
                      _sortItem('harga_desc', 'Harga Tertinggi', _sortBy),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category filter
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _viewModel.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final sel = _viewModel.selectedCategory == _viewModel.categories[i];
                  return GestureDetector(
                    onTap: () => _viewModel.setCategory(_viewModel.categories[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFFB8973A)
                            : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel
                              ? const Color(0xFFB8973A)
                              : const Color(0xFFB8973A).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        _viewModel.categories[i],
                        style: TextStyle(
                          color: sel ? Colors.black : Colors.white60,
                          fontSize: 13,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Grid
            Expanded(
              child: _viewModel.loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFB8973A)))
                  : _viewModel.books.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada buku dalam kategori "${_viewModel.selectedCategory}"',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 14),
                          ),
                        )
                      : RefreshIndicator(
                          color: const Color(0xFFB8973A),
                          backgroundColor: const Color(0xFF1A1A1A),
                          onRefresh: _viewModel.load,
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                            itemCount: _viewModel.books.length,
                            itemBuilder: (ctx, i) {
                              return _CatalogCard(
                                book: _viewModel.books[i],
                                userId: widget.currentUser.id ?? 0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BuyerBookDetailScreen(
                                        book: _viewModel.books[i],
                                        currentUser: widget.currentUser,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _sortItem(String val, String label, String cur) =>
      PopupMenuItem(
        value: val,
        child: Row(
          children: [
            Icon(
              cur == val ? Icons.check : Icons.radio_button_unchecked,
              color: cur == val ? const Color(0xFFB8973A) : Colors.white38,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: cur == val ? const Color(0xFFB8973A) : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
}

class _CatalogCard extends StatefulWidget {
  final Book book;
  final int userId;
  final VoidCallback onTap;

  const _CatalogCard({
    required this.book,
    required this.userId,
    required this.onTap,
  });

  @override
  State<_CatalogCard> createState() => _CatalogCardState();
}

class _CatalogCardState extends State<_CatalogCard> {
  bool _inWish = false;
  final _wishlistRepo = WishlistRepository();

  @override
  void initState() {
    super.initState();
    _checkWish();
  }

  Future<void> _checkWish() async {
    if (widget.book.id == null) return;
    final r = await _wishlistRepo.isInWishlist(widget.userId, widget.book.id!);
    if (mounted) setState(() => _inWish = r);
  }

  Future<void> _toggleWish() async {
    if (widget.book.id == null) return;
    if (_inWish) {
      await _wishlistRepo.remove(widget.userId, widget.book.id!);
    } else {
      await _wishlistRepo.add(widget.userId, widget.book.id!);
    }
    setState(() => _inWish = !_inWish);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFFB8973A).withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.08),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book,
                        color: Color(0xFFB8973A), size: 50),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleWish,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _inWish ? Icons.favorite : Icons.favorite_border,
                        color: _inWish ? Colors.red : Colors.white54,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.book.judul,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.penulis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${_fmt(widget.book.harga.toInt())}',
                          style: const TextStyle(
                            color: Color(0xFFB8973A),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
