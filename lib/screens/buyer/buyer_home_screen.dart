import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/user.dart';
import '../../viewmodels/buyer/buyer_home_viewmodel.dart';
import 'buyer_book_detail_screen.dart';

/// BuyerHomeScreen — Halaman utama buyer
/// Path: lib/screens/buyer/buyer_home_screen.dart
class BuyerHomeScreen extends StatefulWidget {
  final User currentUser;
  final void Function(int) onTabChange;
  const BuyerHomeScreen({
    super.key,
    required this.currentUser,
    required this.onTabChange,
  });

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final _viewModel = BuyerHomeViewModel();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.loadBooks();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    await _viewModel.search(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: _viewModel.loading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFB8973A)))
            : RefreshIndicator(
                color: const Color(0xFFB8973A),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: _viewModel.loadBooks,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, ${widget.currentUser.nama.split(' ').first} ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Temukan buku favoritmu hari ini',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const _WishlistBtn(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: _search,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Cari judul atau penulis...',
                          hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 14),
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.white38, size: 20),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white38, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    _viewModel.loadBooks();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFFB8973A)
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFB8973A), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Featured carousel
                    if (_viewModel.featured.isNotEmpty && _searchCtrl.text.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _SectionHeader(
                          title: 'Buku Unggulan',
                          onSeeAll: () => widget.onTabChange(1),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 210,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _viewModel.featured.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemBuilder: (ctx, i) => _FeaturedCard(
                            book: _viewModel.featured[i],
                            onTap: () => _toDetail(_viewModel.featured[i]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                    // All books
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _SectionHeader(
                        title: _searchCtrl.text.isEmpty
                            ? 'Semua Buku'
                            : 'Hasil Pencarian',
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_viewModel.allBooks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            'Buku tidak ditemukan',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _viewModel.allBooks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) => _BookListTile(
                          book: _viewModel.allBooks[i],
                          onTap: () => _toDetail(_viewModel.allBooks[i]),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  void _toDetail(Book b) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BuyerBookDetailScreen(
            book: b,
            currentUser: widget.currentUser,
          ),
        ),
      );
}

// ── Widgets ────────────────────────────────────────────────────────────────

class _WishlistBtn extends StatelessWidget {
  const _WishlistBtn();

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.favorite_border, color: Color(0xFFB8973A)),
        onPressed: () {},
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'Lihat Semua',
                style: TextStyle(color: Color(0xFFB8973A), fontSize: 13),
              ),
            ),
        ],
      );
}

class _FeaturedCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  const _FeaturedCard({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFFB8973A).withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFB8973A).withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Center(
                child:
                    Icon(Icons.menu_book, color: Color(0xFFB8973A), size: 44),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.judul,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${_fmt(book.harga.toInt())}',
                    style: const TextStyle(
                      color: Color(0xFFB8973A),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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

class _BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  const _BookListTile({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFB8973A).withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_book_outlined,
                    color: Color(0xFFB8973A), size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.judul,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      book.penulis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFB8973A).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            book.kategori,
                            style: const TextStyle(
                              color: Color(0xFFB8973A),
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rp ${_fmt(book.harga.toInt())}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

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
