import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_users_viewmodel.dart';
import '../../models/user.dart';

/// AdminUsersScreen — Daftar Pengguna (Seller & Buyer)
/// Path: lib/screens/admin/admin_users_screen.dart
class AdminUsersScreen extends StatefulWidget {
  final User currentUser;
  const AdminUsersScreen({super.key, required this.currentUser});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen>
    with SingleTickerProviderStateMixin {
  final _viewModel = AdminUsersViewModel();
  late TabController _tab;

  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
    _viewModel.load();
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchCtrl.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _toggleStatus(User user) async {
    final newStatus = !user.isActive;
    await _viewModel.toggleUserStatus(user);
    if (!mounted) return;
    _snack(
        newStatus ? '${user.nama} diaktifkan.' : '${user.nama} dinonaktifkan.');
  }

  Future<void> _confirmDelete(User user) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text('Hapus ${user.nama}?',
            style: const TextStyle(color: Colors.white)),
        content: Text('Data pengguna ini akan dihapus permanen.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child:
                  const Text('Batal', style: TextStyle(color: Colors.white54))),
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
    );
    if (ok == true) {
      await _viewModel.deleteUser(user);
      if (!mounted) return;
      _snack('${user.nama} dihapus.');
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
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => Column(children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(children: [
                const Text('Daftar Pengguna',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8973A).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFB8973A).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${_viewModel.sellers.length + _viewModel.buyers.length} user',
                    style: const TextStyle(
                        color: Color(0xFFB8973A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            // ── Search ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => _viewModel.setSearchQuery(v),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari nama atau email...',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3), fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white38, size: 20),
                  suffixIcon: _viewModel.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white38, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            _viewModel.setSearchQuery('');
                          })
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: const Color(0xFFB8973A).withValues(alpha: 0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFFB8973A), width: 1.5)),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: [
                    Tab(text: 'Seller (${_viewModel.sellers.length})'),
                    Tab(text: 'Buyer (${_viewModel.buyers.length})'),
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
                        _UserList(
                          users: _viewModel.filterUsers(_viewModel.sellers),
                          emptyLabel: 'Belum ada seller terdaftar',
                          onToggle: _toggleStatus,
                          onDelete: _confirmDelete,
                        ),
                        _UserList(
                          users: _viewModel.filterUsers(_viewModel.buyers),
                          emptyLabel: 'Belum ada buyer terdaftar',
                          onToggle: _toggleStatus,
                          onDelete: _confirmDelete,
                        ),
                      ],
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── User List ───────────────────────────────────────────────────────────────

class _UserList extends StatelessWidget {
  final List<User> users;
  final String emptyLabel;
  final void Function(User) onToggle;
  final void Function(User) onDelete;

  const _UserList({
    required this.users,
    required this.emptyLabel,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.people_outline, color: Colors.white12, size: 60),
          const SizedBox(height: 12),
          Text(emptyLabel,
              style: const TextStyle(color: Colors.white38, fontSize: 14)),
        ]),
      );
    }
    return RefreshIndicator(
      color: const Color(0xFFB8973A),
      backgroundColor: const Color(0xFF1A1A1A),
      onRefresh: () async {},
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) => _UserTile(
          user: users[i],
          onToggle: () => onToggle(users[i]),
          onDelete: () => onDelete(users[i]),
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _UserTile(
      {required this.user, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isActive = user.isActive;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isActive
                ? const Color(0xFFB8973A).withValues(alpha: 0.15)
                : Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        // Avatar
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFB8973A).withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            user.role == 'seller'
                ? Icons.storefront_outlined
                : Icons.person_outline,
            color: isActive ? const Color(0xFFB8973A) : Colors.grey,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        // Info
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(user.nama,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(isActive ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 3),
          Text(user.email,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(user.phone,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
        ])),
        // Actions
        Column(children: [
          // Toggle aktif/nonaktif
          GestureDetector(
            onTap: onToggle,
            child: Tooltip(
              message: isActive ? 'Nonaktifkan' : 'Aktifkan',
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isActive ? Icons.block : Icons.check_circle_outline,
                  color: isActive ? Colors.red : Colors.green,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Hapus
          GestureDetector(
            onTap: onDelete,
            child: Tooltip(
              message: 'Hapus',
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 18),
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
