import 'package:flutter/material.dart';
import '../../viewmodels/seller/seller_book_list_viewmodel.dart';
import '../../models/book.dart';
import '../../models/user.dart';

/// SellerBookListScreen — "Buku Saya" untuk Seller
/// Buku yang ditambah otomatis status 'pending' menunggu approval admin
/// Path: lib/screens/seller/seller_book_list_screen.dart
class SellerBookListScreen extends StatefulWidget {
  final User currentUser;
  const SellerBookListScreen({super.key, required this.currentUser});

  @override
  State<SellerBookListScreen> createState() => _SellerBookListScreenState();
}

class _SellerBookListScreenState extends State<SellerBookListScreen>
    with SingleTickerProviderStateMixin {
  final _viewModel = SellerBookListViewModel();
  late TabController _tab;
  final List<String> _statusLabels = [
    'Semua',
    'Pending',
    'Disetujui',
    'Ditolak'
  ];

  @override
  void initState() {
    super.initState();
    _viewModel.init(widget.currentUser);
    _viewModel.addListener(_onViewModelChanged);
    _tab = TabController(length: 4, vsync: this);
    _tab.addListener(() {
      if (_tab.index != _viewModel.selectedTab) {
        _viewModel.setSelectedTab(_tab.index);
      }
    });
    _viewModel.load();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tab.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _showAddEditDialog({Book? book}) async {
    final categories = _viewModel.categories;
    if (!mounted) return;

    final isEdit = book != null;
    final judulCtrl = TextEditingController(text: book?.judul ?? '');
    final penulisCtrl = TextEditingController(text: book?.penulis ?? '');
    final hargaCtrl = TextEditingController(
        text: book != null ? book.harga.toStringAsFixed(0) : '');
    final stokCtrl =
        TextEditingController(text: book != null ? book.stok.toString() : '');
    final deskCtrl = TextEditingController(text: book?.deskripsi ?? '');
    String selectedKat =
        book?.kategori ?? (categories.isNotEmpty ? categories.first : 'Fiksi');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          title: Text(
            isEdit ? 'Edit Buku' : 'Tambah Buku Baru',
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (!isEdit)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: const Row(children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 14),
                      SizedBox(width: 6),
                      Expanded(
                          child: Text(
                        'Buku akan berstatus Pending hingga disetujui Admin.',
                        style: TextStyle(color: Colors.orange, fontSize: 11),
                      )),
                    ]),
                  ),
                _DlgField(
                    ctrl: judulCtrl, label: 'Judul Buku', icon: Icons.title),
                const SizedBox(height: 10),
                _DlgField(
                    ctrl: penulisCtrl,
                    label: 'Penulis',
                    icon: Icons.person_outline),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: categories.contains(selectedKat)
                      ? selectedKat
                      : (categories.isNotEmpty ? categories.first : null),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 13),
                    prefixIcon: const Icon(Icons.label_outline,
                        color: Colors.white38, size: 18),
                    filled: true,
                    fillColor: const Color(0xFF0F0F0F),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: const Color(0xFFB8973A)
                                .withValues(alpha: 0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFFB8973A), width: 1.5)),
                  ),
                  items: categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setDlg(() => selectedKat = v ?? selectedKat),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: _DlgField(
                          ctrl: hargaCtrl,
                          label: 'Harga (Rp)',
                          icon: Icons.attach_money,
                          keyType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _DlgField(
                          ctrl: stokCtrl,
                          label: 'Stok',
                          icon: Icons.inventory_2_outlined,
                          keyType: TextInputType.number)),
                ]),
                const SizedBox(height: 10),
                _DlgField(
                    ctrl: deskCtrl,
                    label: 'Deskripsi',
                    icon: Icons.description_outlined,
                    maxLines: 3),
              ]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Batal', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8973A),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final judul = judulCtrl.text.trim();
                final penulis = penulisCtrl.text.trim();
                final harga = double.tryParse(hargaCtrl.text) ?? 0;
                final stok = int.tryParse(stokCtrl.text) ?? 0;
                final desk = deskCtrl.text.trim();
                if (judul.isEmpty || penulis.isEmpty || desk.isEmpty) return;

                Navigator.pop(ctx);

                if (isEdit) {
                  final updated = book.copyWith(
                    judul: judul,
                    penulis: penulis,
                    kategori: selectedKat,
                    harga: harga,
                    stok: stok,
                    deskripsi: desk,
                  );
                  await _viewModel.updateBook(updated);
                  _snack('Buku diperbarui.');
                } else {
                  await _viewModel.addBook(
                      judul, penulis, selectedKat, harga, stok, desk);
                  _snack('Buku diajukan! Menunggu persetujuan Admin.');
                }
              },
              child: Text(isEdit ? 'Simpan' : 'Ajukan Buku',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteBook(Book book) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text('Hapus Buku?',
                style: TextStyle(color: Colors.white, fontSize: 15)),
            content: Text('"${book.judul}" akan dihapus permanen.',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal',
                      style: TextStyle(color: Colors.white54))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
    if (ok) {
      await _viewModel.deleteBook(book);
      _snack('Buku dihapus.');
    }
  }

  void _snack(String msg, {bool err = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: err ? Colors.red.shade700 : const Color(0xFFB8973A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              const Text('Buku Saya',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
                ),
                child: Text('${_viewModel.books.length} buku',
                    style: const TextStyle(
                        color: Color(0xFFB8973A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          // Status tab filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.15)),
              ),
              child: TabBar(
                controller: _tab,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    color: const Color(0xFFB8973A),
                    borderRadius: BorderRadius.circular(9)),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white54,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                onTap: (index) => _viewModel.setSelectedTab(index),
                tabs: _statusLabels.map((s) => Tab(text: s)).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // List
          Expanded(
            child: _viewModel.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB8973A)))
                : _viewModel.books.isEmpty
                    ? _EmptyState(onAdd: () => _showAddEditDialog())
                    : RefreshIndicator(
                        color: const Color(0xFFB8973A),
                        backgroundColor: const Color(0xFF1A1A1A),
                        onRefresh: _viewModel.load,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                          itemCount: _viewModel.books.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (ctx, i) => _BookCard(
                            book: _viewModel.books[i],
                            onEdit: () =>
                                _showAddEditDialog(book: _viewModel.books[i]),
                            onDelete: () => _deleteBook(_viewModel.books[i]),
                          ),
                        ),
                      ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFFB8973A),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Ajukan Buku',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ),
    );
  }
}

// ─── Book Card ───────────────────────────────────────────────────────────────

class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onEdit, onDelete;
  const _BookCard(
      {required this.book, required this.onEdit, required this.onDelete});

  Color get _statusColor {
    switch (book.status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String get _statusLabel {
    switch (book.status) {
      case 'approved':
        return '✅ Disetujui';
      case 'rejected':
        return '❌ Ditolak';
      default:
        return '⏳ Menunggu';
    }
  }

  IconData get _statusIcon {
    switch (book.status) {
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.pending_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor.withValues(alpha: 0.25)),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Cover
            Container(
                width: 56,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu_book,
                    color: Color(0xFFB8973A), size: 28)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Judul + status
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Text(book.judul,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_statusIcon, color: _statusColor, size: 10),
                        const SizedBox(width: 3),
                        Text(_statusLabel,
                            style: TextStyle(
                                color: _statusColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(book.penulis,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12)),
                  const SizedBox(height: 6),
                  // Chips
                  Wrap(spacing: 6, runSpacing: 4, children: [
                    _Pill(Icons.label_outline, book.kategori),
                    _Pill(Icons.inventory_2_outlined, 'Stok: ${book.stok}'),
                  ]),
                  const SizedBox(height: 6),
                  Text('Rp ${_fmt(book.harga.toInt())}',
                      style: const TextStyle(
                          color: Color(0xFFB8973A),
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  if (book.status == 'rejected')
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Buku ditolak admin. Edit & ajukan ulang.',
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                    ),
                ])),
          ]),
        ),
        // Action row
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Row(children: [
            Expanded(
                child: SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB8973A),
                  side: BorderSide(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            )),
            const SizedBox(width: 10),
            SizedBox(
              height: 36,
              width: 38,
              child: OutlinedButton(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.delete_outline, size: 18),
              ),
            ),
          ]),
        ),
      ]),
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

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFB8973A).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: const Color(0xFFB8973A), size: 11),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Color(0xFFB8973A), fontSize: 10)),
      ]));
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.menu_book_outlined, color: Colors.white12, size: 72),
          const SizedBox(height: 16),
          const Text('Belum ada buku',
              style: TextStyle(
                  color: Colors.white38,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Tekan tombol "Ajukan Buku" untuk mulai',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25), fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Ajukan Buku Pertama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB8973A),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
          ),
        ]),
      );
}

// ─── Dialog Field ─────────────────────────────────────────────────────────────

class _DlgField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType? keyType;
  final int maxLines;
  const _DlgField(
      {required this.ctrl,
      required this.label,
      required this.icon,
      this.keyType,
      this.maxLines = 1});
  @override
  Widget build(BuildContext context) => TextField(
      controller: ctrl,
      keyboardType: keyType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.45), fontSize: 13),
        prefixIcon:
            maxLines == 1 ? Icon(icon, color: Colors.white38, size: 18) : null,
        filled: true,
        fillColor: const Color(0xFF0F0F0F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: const Color(0xFFB8973A).withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB8973A), width: 1.5)),
      ));
}
