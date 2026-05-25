import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_books_viewmodel.dart';
import '../../models/book.dart';
import '../../models/category.dart';
import '../../models/user.dart';

/// AdminBooksScreen — Daftar Buku (Approve/Reject) + Kelola Kategori
/// Path: lib/screens/admin/admin_books_screen.dart
class AdminBooksScreen extends StatefulWidget {
  final User currentUser;
  const AdminBooksScreen({super.key, required this.currentUser});

  @override
  State<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends State<AdminBooksScreen>
    with SingleTickerProviderStateMixin {
  final _viewModel = AdminBooksViewModel();
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
    _viewModel.load();
  }

  @override
  void dispose() {
    _tab.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  // ── Approve / Reject ──────────────────────────────────────────────────────
  Future<void> _approve(Book book) async {
    await _viewModel.approveBook(book);
    if (!mounted) return;
    _snack('✅ "${book.judul}" disetujui.');
  }

  Future<void> _reject(Book book) async {
    await _viewModel.rejectBook(book);
    if (!mounted) return;
    _snack('❌ "${book.judul}" ditolak.', err: true);
  }

  Future<void> _deleteBook(Book book) async {
    final ok = await _confirmDialog(
        'Hapus buku?', '"${book.judul}" akan dihapus permanen.');
    if (ok) {
      await _viewModel.deleteBook(book);
      if (!mounted) return;
      _snack('Buku dihapus.');
    }
  }

  // ── Kategori ──────────────────────────────────────────────────────────────
  void _showAddCategoryDialog() => _showCategoryDialog();
  void _showEditCategoryDialog(BookCategory cat) =>
      _showCategoryDialog(cat: cat);

  void _showCategoryDialog({BookCategory? cat}) {
    final isEdit = cat != null;
    final namaCtrl = TextEditingController(text: cat?.nama ?? '');
    final descCtrl = TextEditingController(text: cat?.deskripsi ?? '');
    bool isActive = cat?.isActive ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(isEdit ? 'Edit Kategori' : 'Tambah Kategori',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            _DlgField(
                ctrl: namaCtrl,
                label: 'Nama Kategori',
                icon: Icons.label_outline),
            const SizedBox(height: 12),
            _DlgField(
                ctrl: descCtrl,
                label: 'Deskripsi (opsional)',
                icon: Icons.description_outlined),
            if (isEdit) ...[
              const SizedBox(height: 12),
              Row(children: [
                Text('Status Aktif',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14)),
                const Spacer(),
                Switch(
                  value: isActive,
                  onChanged: (v) => setDlg(() => isActive = v),
                  activeColor: const Color(0xFFB8973A),
                ),
              ]),
            ],
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal',
                    style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8973A),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () async {
                final nama = namaCtrl.text.trim();
                if (nama.isEmpty) return;
                Navigator.pop(ctx);
                if (isEdit) {
                  await _viewModel.updateCategory(cat.copyWith(
                      nama: nama,
                      deskripsi: descCtrl.text.trim(),
                      isActive: isActive));
                  if (!mounted) return;
                  _snack('Kategori diperbarui.');
                } else {
                  await _viewModel.addCategory(nama,
                      deskripsi: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim());
                  if (!mounted) return;
                  _snack('Kategori ditambahkan.');
                }
              },
              child: Text(isEdit ? 'Simpan' : 'Tambah',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCategory(BookCategory cat) async {
    final ok = await _confirmDialog('Hapus kategori?',
        '"${cat.nama}" akan dihapus. Buku dalam kategori ini tidak ikut terhapus.');
    if (ok) {
      await _viewModel.deleteCategory(cat);
      if (!mounted) return;
      _snack('Kategori dihapus.');
    }
  }

  Future<bool> _confirmDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
            content: Text(content,
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
                  child: const Text('Hapus')),
            ],
          ),
        ) ??
        false;
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
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => Column(children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(children: [
                const Text('Daftar Buku',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                // Tombol kelola kategori
                GestureDetector(
                  onTap: _showCategoryManagement,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
                    ),
                    child: const Row(children: [
                      Icon(Icons.category_outlined,
                          color: Color(0xFFB8973A), size: 16),
                      SizedBox(width: 6),
                      Text('Kategori',
                          style: TextStyle(
                              color: Color(0xFFB8973A),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            // ── Tab bar ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(4),
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
                      borderRadius: BorderRadius.circular(8)),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white54,
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  tabs: [
                    Tab(text: 'Pending (${_viewModel.pending.length})'),
                    Tab(text: 'Disetujui (${_viewModel.approved.length})'),
                    Tab(text: 'Ditolak (${_viewModel.rejected.length})'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // ── Tab content ───────────────────────────────────────────────────
            Expanded(
              child: _viewModel.loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFFB8973A)))
                  : TabBarView(
                      controller: _tab,
                      children: [
                        _BookList(
                          books: _viewModel.pending,
                          emptyLabel: 'Tidak ada buku pending',
                          emptyIcon: Icons.pending_outlined,
                          showApprove: true,
                          showReject: true,
                          onApprove: _approve,
                          onReject: _reject,
                          onDelete: _deleteBook,
                        ),
                        _BookList(
                          books: _viewModel.approved,
                          emptyLabel: 'Tidak ada buku disetujui',
                          emptyIcon: Icons.check_circle_outline,
                          showApprove: false,
                          showReject: true,
                          onApprove: _approve,
                          onReject: _reject,
                          onDelete: _deleteBook,
                        ),
                        _BookList(
                          books: _viewModel.rejected,
                          emptyLabel: 'Tidak ada buku ditolak',
                          emptyIcon: Icons.cancel_outlined,
                          showApprove: true,
                          showReject: false,
                          onApprove: _approve,
                          onReject: _reject,
                          onDelete: _deleteBook,
                        ),
                      ],
                    ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Sheet kelola kategori ─────────────────────────────────────────────────
  void _showCategoryManagement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (ctx, scrollCtrl) => ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => Column(children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
            // Title + Add btn
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
              child: Row(children: [
                const Text('Kelola Kategori',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showAddCategoryDialog();
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8973A),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ]),
            ),
            // List
            Expanded(
              child: _viewModel.categories.isEmpty
                  ? Center(
                      child: Text('Belum ada kategori',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 14)))
                  : ListView.separated(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _viewModel.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final cat = _viewModel.categories[i];
                        return Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F0F0F),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: cat.isActive
                                    ? const Color(0xFFB8973A)
                                        .withValues(alpha: 0.2)
                                    : Colors.red.withValues(alpha: 0.2)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: cat.isActive
                                    ? const Color(0xFFB8973A)
                                        .withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.label,
                                  color: cat.isActive
                                      ? const Color(0xFFB8973A)
                                      : Colors.grey,
                                  size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text(cat.nama,
                                      style: TextStyle(
                                          color: cat.isActive
                                              ? Colors.white
                                              : Colors.white54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  if (cat.deskripsi != null &&
                                      cat.deskripsi!.isNotEmpty)
                                    Text(cat.deskripsi!,
                                        style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.35),
                                            fontSize: 11),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                ])),
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: cat.isActive
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(cat.isActive ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                      color: cat.isActive
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 6),
                            // Edit
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Color(0xFFB8973A), size: 18),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showEditCategoryDialog(cat);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 32, minHeight: 32),
                            ),
                            // Delete
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 18),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _deleteCategory(cat);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 32, minHeight: 32),
                            ),
                          ]),
                        );
                      }),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── Book List ───────────────────────────────────────────────────────────────

class _BookList extends StatelessWidget {
  final List<Book> books;
  final String emptyLabel;
  final IconData emptyIcon;
  final bool showApprove, showReject;
  final void Function(Book) onApprove, onReject, onDelete;

  const _BookList({
    required this.books,
    required this.emptyLabel,
    required this.emptyIcon,
    required this.showApprove,
    required this.showReject,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(emptyIcon, color: Colors.white12, size: 60),
          const SizedBox(height: 12),
          Text(emptyLabel,
              style: const TextStyle(color: Colors.white38, fontSize: 14)),
        ]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _BookCard(
        book: books[i],
        showApprove: showApprove,
        showReject: showReject,
        onApprove: () => onApprove(books[i]),
        onReject: () => onReject(books[i]),
        onDelete: () => onDelete(books[i]),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final bool showApprove, showReject;
  final VoidCallback onApprove, onReject, onDelete;

  const _BookCard({
    required this.book,
    required this.showApprove,
    required this.showReject,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
  });

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
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(children: [
        // Info row
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Cover placeholder
            Container(
                width: 52,
                height: 68,
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
                  Row(children: [
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
                      child: Text(_statusLabel,
                          style: TextStyle(
                              color: _statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(book.penulis,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, children: [
                    _InfoPill(Icons.label_outline, book.kategori),
                    _InfoPill(Icons.inventory_2_outlined, 'Stok: ${book.stok}'),
                  ]),
                  const SizedBox(height: 6),
                  Text('Rp ${_fmt(book.harga.toInt())}',
                      style: const TextStyle(
                          color: Color(0xFFB8973A),
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(book.deskripsi,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ])),
          ]),
        ),
        // Action buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Row(children: [
            if (showApprove)
              Expanded(
                  child: _ActionBtn(
                label: 'Setujui',
                icon: Icons.check_circle_outline,
                color: Colors.green,
                onTap: onApprove,
              )),
            if (showApprove && showReject) const SizedBox(width: 8),
            if (showReject)
              Expanded(
                  child: _ActionBtn(
                label: 'Tolak',
                icon: Icons.cancel_outlined,
                color: Colors.red,
                onTap: onReject,
              )),
            const SizedBox(width: 8),
            _DeleteBtn(onTap: onDelete),
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

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill(this.icon, this.label);
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
        ]),
      );
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            textStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            padding: const EdgeInsets.symmetric(horizontal: 10)),
      ));
}

class _DeleteBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteBtn({required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 38,
      width: 38,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.12),
              foregroundColor: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              padding: EdgeInsets.zero),
          child: const Icon(Icons.delete_outline, size: 18)));
}

// ── Dialog field ─────────────────────────────────────────────────────────────

class _DlgField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  const _DlgField(
      {required this.ctrl, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.45), fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
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
